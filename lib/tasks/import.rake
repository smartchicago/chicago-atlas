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
        {:category => 'Births', :name => 'Prenatal Care', :group_column => 'Trimester Prenatal Care Began', :groups => ['1ST TRIMESTER', '2ND TRIMESTER', '3RD TRIMESTER', 'NO PRENATAL CARE', 'NOT GIVEN'], :parse_tokens => ['Percent'], :socrata_id => '2q9j-hh6g', :url => 'https://data.cityofchicago.org/Health-Human-Services/Public-Health-Statistics-Prenatal-care-in-Chicago-/2q9j-hh6g'},
        
        # Deaths
        {:category => 'Deaths', :name => 'Infant Mortality', :parse_tokens => ['Deaths'], :socrata_id => 'bfhr-4ckq', :url => 'https://data.cityofchicago.org/Health-Human-Services/Public-Health-Statistics-Infant-mortality-in-Chica/bfhr-4ckq'},

        # special case: broken down by death cause
        # causes: All causes in females,All causes in males,Alzheimers disease,Assault (homicide),Breast cancer in females,Cancer (all sites),Colorectal cancer,Coronary heart disease,Diabetes-related,Firearm-related,Injury, unintentional,Kidney disease (nephritis, nephrotic syndrome and nephrosis),Liver disease and cirrhosis,Lung cancer,Prostate cancer in males,Stroke (cerebrovascular disease),Suicide (intentional self-harm)
        # {:category => 'Deaths', :name => 'Mortality', :parse_tokens => [], :socrata_id => 'j6cj-r444', :url => 'https://data.cityofchicago.org/Health-Human-Services/Public-Health-Statistics-Selected-underlying-cause/j6cj-r444'},
      
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

          if d.has_key?(:group_column) and d.has_key?(:groups)
            puts "unpacking groups based on '#{d[:group_column]}' column"
            d[:groups].each do |group|
              # save each data portal set, parse_token and group combination as a separate dataset
              dataset = save_cdph_dataset(d, parse_token, handle, group)

              csv.each do |row|
                process_cdph_row(row, dataset, parse_token, d[:group_column], group)
              end

              stat_count = Statistic.count(:conditions => "dataset_id = #{dataset.id}")
              puts "#{parse_token}, #{group}: imported #{stat_count} statistics"
            end
          else
            # save each data portal set and parse_token combination as a separate dataset
            dataset = save_cdph_dataset(d, parse_token, handle)

            csv.each do |row|
              process_cdph_row(row, dataset, parse_token)
            end

            stat_count = Statistic.count(:conditions => "dataset_id = #{dataset.id}")
            puts "#{parse_token}: imported #{stat_count} statistics"
          end
        end
      end
      puts 'Done!'
    end

    def save_cdph_dataset(d, parse_token, handle, group='')

      name = "#{d[:name]} - #{parse_token}"
      if group != ''
        name << " - #{group}"
      end
      dataset = Dataset.new(
        :name => name,
        :slug => handle,
        :description => '', # leaving blank for now
        :provider => 'Chicago Department of Public Health',
        :url => d[:url],
        :category_id => Category.where(:name => d[:category]).first.id
      )
      dataset.save!
      dataset
    end

    def process_cdph_row(row, dataset, parse_token, group_column='', group='')
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

      if group != '' and group_column != ''
        if row[group_column] == group
          save_cdph_statistic(row, dataset, community_area, parse_token)
        end
      else
        save_cdph_statistic(row, dataset, community_area, parse_token)
      end
    end

    def save_cdph_statistic(row, dataset, community_area, parse_token)
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

    desc "Populate dataset descriptions"
    task :chicago_dph_descriptions => :environment do
      descriptions = [
        # Births
        {:name => 'Births and Birth Rate - Birth Rate', :description => "Crude birth rate (births per 1,000 residents) with corresponding 95% confidence intervals, by Chicago community area, for the years 1999 - 2009."},
        {:name => 'Births and Birth Rate - Births', :description => "Annual number of births by Chicago community area, for the years 1999 - 2009." },
        {:name => 'General Fertility Rate - Fertility Rate', :description => "Annual general fertility rate (births per 1,000 females aged 15-44 years) with corresponding 95% confidence intervals, by Chicago community area, for the years 1999 - 2009." },
        {:name => 'Low Birth Weight - Births', :description => "Annual number of low birth weight births by Chicago community area, for the years 1999 - 2009." },
        {:name => 'Low Birth Weight - Percent', :description => "Percent of total births these low birth weight births represent, with corresponding 95% confidence intervals, by Chicago community area, for the years 1999 - 2009." },
        {:name => 'Prenatal Care - Percent - 1ST TRIMESTER', :description => "Percent of live births by the trimester in which the mother began prenatal care, with corresponding 95% confidence intervals, by Chicago community area, for the years 1999 - 2009." },
        {:name => 'Prenatal Care - Percent - 2ND TRIMESTER', :description => "Percent of live births by the trimester in which the mother began prenatal care, with corresponding 95% confidence intervals, by Chicago community area, for the years 1999 - 2009." },
        {:name => 'Prenatal Care - Percent - 3RD TRIMESTER', :description => "Percent of live births by the trimester in which the mother began prenatal care, with corresponding 95% confidence intervals, by Chicago community area, for the years 1999 - 2009." },
        {:name => 'Prenatal Care - Percent - NO PRENATAL CARE', :description => "Percent of live births by the trimester in which the mother began prenatal care, with corresponding 95% confidence intervals, by Chicago community area, for the years 1999 - 2009." },
        {:name => 'Prenatal Care - Percent - NOT GIVEN', :description => "Percent of live births by the trimester in which the mother began prenatal care, with corresponding 95% confidence intervals, by Chicago community area, for the years 1999 - 2009." },
        {:name => 'Preterm Births - Percent', :description => "Percent of total births these preterm births represent, with corresponding 95% confidence intervals, by Chicago community area, for the years 1999 - 2009." },
        {:name => 'Preterm Births - Pre-term Births', :description => "Annual number of preterm births  by Chicago community area, for the years 1999 - 2009." },
        {:name => 'Teen Births - Teen Birth Rate', :description => "Annual birth rate (births per 1,000 females aged 15-19 years) with corresponding 95% confidence intervals, by Chicago community area, for the years 1999 - 2009." },
        {:name => 'Teen Births - Teen Births', :description => "Annual number of births to mothers aged 15-19 years old by Chicago community area, for the years 1999 - 2009." },
        
        # Deaths
        {:name => 'Infant Mortality - Deaths', :description => "Annual number of infant deaths, by Chicago community area, for the years 2004 - 2008." },
        
        # Environmental Health
        {:name => 'Lead - Elevated Blood Lead Level in', :description => "Annual number and estimated rate per 1,000 children aged 0-6 years receiving a blood lead level test, and the annual number and estimated percentage of those tested found to have an elevated blood lead level, with corresponding 95% confidence intervals, by Chicago community area, for the years 1999 - 2011." },
        {:name => 'Lead - Lead Screening Rate', :description => "Annual number and estimated rate per 1,000 children aged 0-6 years receiving a blood lead level test, and the annual number and estimated percentage of those tested found to have an elevated blood lead level, with corresponding 95% confidence intervals, by Chicago community area, for the years 1999 - 2011." },
        {:name => 'Lead - Percent Elevated', :description => "Annual number and estimated rate per 1,000 children aged 0-6 years receiving a blood lead level test, and the annual number and estimated percentage of those tested found to have an elevated blood lead level, with corresponding 95% confidence intervals, by Chicago community area, for the years 1999 - 2011." },
        {:name => 'Lead - Screened for Lead in', :description => "Annual number and estimated rate per 1,000 children aged 0-6 years receiving a blood lead level test, and the annual number and estimated percentage of those tested found to have an elevated blood lead level, with corresponding 95% confidence intervals, by Chicago community area, for the years 1999 - 2011." },
        
        # Infectious disease
        {:name => 'Chlamydia in females - Incidence Rate', :description => "Annual number of newly reported, laboratory-confirmed cases of chlamydia (Chlamydia trachomatis) among females aged 15-44 years and annual chlamydia incidence rate (cases per 100,000 females aged 15-44 years) with corresponding 95% confidence intervals by Chicago community area, for years 2000 - 2011. " },
        {:name => 'Gonorrhea in females - Incidence Rate', :description => "Annual number of newly reported, laboratory-confirmed cases of gonorrhea (Neisseria gonorrhoeae) among females aged 15-44 years and annual gonorrhea incidence rate (cases per 100,000 females aged 15-44 years) with corresponding 95% confidence intervals by Chicago community area, for years 2000 - 2011." },
        {:name => 'Gonorrhea in males - Incidence Rate', :description => "Annual number of newly reported, laboratory-confirmed cases of gonorrhea (Neisseria gonorrhoeae) among males aged 15-44 years and annual gonorrhea incidence rate (cases per 100,000 males aged 15-44 years) with corresponding 95% confidence intervals by Chicago community area, for years 2000 - 2011. " },
        {:name => 'Tuberculosis - Cases', :description => "Annual number of new cases of tuberculosis by Chicago community area, for the years 2007 - 2011." },


      ]

      descriptions.each do |d|
        dataset = Dataset.where(:name => d[:name]).first
        puts "populating description for #{dataset.name}"
        dataset.description = d[:description]
        dataset.save!
      end
    end

  end
end