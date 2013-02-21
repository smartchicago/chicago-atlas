namespace :db do
  namespace :import do
    
    desc "Fetch Chicago Community Areas from the TribApps Boundary Service"
    task :community_areas => :environment do
      require 'open-uri'
      require 'json'
      Geography.delete_all

      community_area_endpoints = JSON.parse(open("http://api.boundaries.tribapps.com/1.0/boundary-set/community-areas/").read)['boundaries']
      community_area_endpoints.each do |endpoint|
        area_json = JSON.parse(open("http://api.boundaries.tribapps.com/#{endpoint}").read)

        area = Geography.new(
          :geo_type => "Community Area",
          :name => area_json['name'],
          :slug => area_json['slug'],
          :geometry => area_json['simple_shape']['coordinates']
        )
        area.id = area_json['external_id']
        puts "importing #{area.name}"
        area.save!
      end

      puts 'Done!'
    end

    desc "Fetch CDPH datasets from the Chicago Data Portal and import to database"
    task :chicago_dph => :environment do
      require 'csv' 

      Dataset.where(:provider => "Chicago Department of Public Health").each do |d|
        Statistic.delete_all("dataset_id = #{d.id}")
        d.delete
      end

      datasets = [
        # Births
        {:category => 'Births', :name => 'Births and Birth Rate', :parse_tokens => ['Births', 'Birth Rate'], :socrata_id => '4arr-givg', :url => 'https://data.cityofchicago.org/Health-Human-Services/Public-Health-Statistics-Births-and-birth-rates-in/4arr-givg'},
        {:category => 'Births', :name => 'General Fertility Rate', :parse_tokens => ['Fertility Rate'], :socrata_id => 'g5zk-9ycw', :url => 'https://data.cityofchicago.org/Health-Human-Services/Public-Health-Statistics-General-fertility-rates-i/g5zk-9ycw'},
        {:category => 'Births', :name => 'Low Birth Weight', :parse_tokens => ['Births', 'Percent'], :socrata_id => 'fbxr-9u99', :url => 'https://data.cityofchicago.org/Health-Human-Services/Public-Health-Statistics-Low-birth-weight-in-Chica/fbxr-9u99'},
        {:category => 'Births', :name => 'Preterm Births', :parse_tokens => ['Pre-term Births', 'Percent'], :socrata_id => 'rhy3-4x2f', :url => 'https://data.cityofchicago.org/Health-Human-Services/Public-Health-Statistics-Preterm-births-in-Chicago/rhy3-4x2f'},
        {:category => 'Births', :name => 'Teen Births', :parse_tokens => ['Teen Births', 'Teen Birth Rate'], :socrata_id => '9kva-bt6k', :url => 'https://data.cityofchicago.org/Health-Human-Services/Public-Health-Statistics-Births-to-mothers-aged-15/9kva-bt6k'},

        # special case: blown up rows for 1ST TRIMESTER, 2ND TRIMESTER, 3RD TRIMESTER, NO PRENATAL CARE, NOT GIVEN
        # {:category => 'Births', :name => 'Parental Care', :parse_tokens => ['Percent'], :socrata_id => '2q9j-hh6g', :url => 'https://data.cityofchicago.org/Health-Human-Services/Public-Health-Statistics-Prenatal-care-in-Chicago-/2q9j-hh6g'},
        
        # Deaths
        # special case: broken down by death cause
        # causes: All causes in females,All causes in males,Alzheimers disease,Assault (homicide),Breast cancer in females,Cancer (all sites),Colorectal cancer,Coronary heart disease,Diabetes-related,Firearm-related,Injury, unintentional,Kidney disease (nephritis, nephrotic syndrome and nephrosis),Liver disease and cirrhosis,Lung cancer,Prostate cancer in males,Stroke (cerebrovascular disease),Suicide (intentional self-harm)
        #{:category => 'Deaths', :name => 'Mortality', :parse_tokens => [], :socrata_id => 'j6cj-r444', :url => 'https://data.cityofchicago.org/Health-Human-Services/Public-Health-Statistics-Selected-underlying-cause/j6cj-r444'},
        {:category => 'Deaths', :name => 'Infant Mortality', :parse_tokens => ['Deaths'], :socrata_id => 'bfhr-4ckq', :url => 'https://data.cityofchicago.org/Health-Human-Services/Public-Health-Statistics-Infant-mortality-in-Chica/bfhr-4ckq'},
      
        # Environmental Health
        {:category => 'Environmental Health', :name => 'Lead', :parse_tokens => ['Screened for Lead in', 'Lead Screening Rate', 'Elevated Blood Lead Level in', 'Percent Elevated'], :socrata_id => 'v2z5-jyrq', :url => 'https://data.cityofchicago.org/Health-Human-Services/Public-Health-Statistics-Screening-for-elevated-bl/v2z5-jyrq'},

        # Infectious disease
        {:category => 'Infectious disease', :name => 'Tuberculosis', :parse_tokens => ['Cases'], :socrata_id => 'ndk3-zftj', :url => 'https://data.cityofchicago.org/Health-Human-Services/Public-Health-Statistics-Tuberculosis-cases-and-av/ndk3-zftj'},
        {:category => 'Infectious disease', :name => 'Gonorrhea in females', :parse_tokens => ['Incidence Rate'], :socrata_id => 'cgjw-mn43', :url => 'https://data.cityofchicago.org/Health-Human-Services/Public-Health-Statistics-Gonorrhea-cases-for-femal/cgjw-mn43'},

        # TODO: accomodate 'Cases 2000 Male 15-44'
        {:category => 'Infectious disease', :name => 'Gonorrhea in males', :parse_tokens => ['Incidence Rate'], :socrata_id => 'm5qn-gmjx', :url => 'https://data.cityofchicago.org/Health-Human-Services/Public-health-statistics-Gonorrhea-cases-for-males/m5qn-gmjx'},

        # TODO: accomodate 'Cases 2000 Female 15-44'
        {:category => 'Infectious disease', :name => 'Chlamydia in females', :parse_tokens => ['Incidence Rate'], :socrata_id => 'bz6k-73ti', :url => 'https://data.cityofchicago.org/Health-Human-Services/Public-Health-Statistics-Chlamydia-cases-among-fem/bz6k-73ti'},

        # Chronic disease
        # these are aggregated by zip code
        # {:category => 'Chronic disease', :name => 'Diabetes Hospitalizations', :parse_tokens => ['Hospitalizations', 'Crude Rate', 'Adjusted Rate'], :socrata_id => 'vekt-28b5', :url => 'https://data.cityofchicago.org/Health-Human-Services/Public-Health-Statistics-Diabetes-hospitalizations/vekt-28b5'},
        # {:category => 'Chronic disease', :name => 'Diabetes Hospitalizations', :parse_tokens => ['Hospitalizations', 'Crude Rate', 'Adjusted Rate'], :socrata_id => 'vazh-t57q', :url => 'https://data.cityofchicago.org/Health-Human-Services/Public-Health-Statistics-Asthma-hospitalizations-i/vazh-t57q'},
      ]

      datasets.each do |d|
        handle = d[:name].parameterize.underscore.to_sym
        
        puts "downloading '#{d[:name]}'"
        sh "curl -o tmp/#{handle}.csv https://data.cityofchicago.org/api/views/#{d[:socrata_id]}/rows.csv?accessType=DOWNLOAD"
      
        csv_text = File.read("tmp/#{handle}.csv")
        csv = CSV.parse(csv_text, :headers => true)

        puts csv.first.inspect

        d[:parse_tokens].each do |parse_token|
          # save each data portal set and parse_token combination as a separate dataset
          dataset = Dataset.new(
            :name => "#{d[:name]} - #{parse_token}",
            :slug => handle,
            :description => '', # leaving blank for now
            :provider => 'Chicago Department of Public Health',
            :url => d[:url],
            :category_id => Category.where(:name => d[:category]).first.id
          )
          dataset.save!

          csv.each do |row|
            row = row.to_hash.with_indifferent_access

            # sometimes Community Area is named differently
            community_area = row['Community Area']
            if community_area.nil? || community_area == ''
              community_area = row['Community Area Number']
            end

            # special case for Chicago - given an ID of 0, 88 or 100 by CDPH
            if community_area == '0' or community_area == '88'
              community_area = '100' # Chicago is manually imported, see seeds.rb
            end

            (1980..Time.now.year).each do |year|
              if (row.has_key?("#{parse_token} #{year}"))
                stat = Statistic.new(
                  :dataset_id => dataset.id,
                  :geography_id => community_area,
                  :year => year,
                  :name => parse_token, 
                  :value => row["#{parse_token} #{year}"]
                )

                if (row.has_key?("#{parse_token} #{year} Lower CI"))
                  stat.lower_ci = row["#{parse_token} #{year} Lower CI"]
                end

                if (row.has_key?("#{parse_token} #{year} Upper CI"))
                  stat.upper_ci = row["#{parse_token} #{year} Upper CI"]
                end

                stat.save!
              end
            end
          end
          stat_count = Statistic.count(:conditions => "dataset_id = #{dataset.id}")
          puts "#{parse_token}: imported #{stat_count} statistics"
        end
      end
      puts 'Done!'
    end
  end
end