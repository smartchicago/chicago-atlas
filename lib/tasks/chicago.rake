namespace :db do
  namespace :import do
    namespace :chicago do
      desc "Fetch CDPH datasets from the Chicago Data Portal and import to database"
      task :dph => :environment do
        require 'csv' 
  
        Dataset.where(:provider => "Chicago Department of Public Health").each do |d|
          Statistic.delete_all("dataset_id = #{d.id}")
          d.delete
        end
  
        datasets = [
          # Births
          {:category => 'Births', :name => 'Birth Rate', :parse_tokens => ['birth_rate'], :socrata_id => '4arr-givg', :url => 'https://data.cityofchicago.org/Health-Human-Services/Public-Health-Statistics-Births-and-birth-rates-in/4arr-givg', :description => "Crude birth rate (births per 1,000 residents) with corresponding 95% confidence intervals, by Chicago community area, for the years 1999 - 2009.", :stat_type => 'rate'},
          {:category => 'Births', :name => 'Fertility Rate', :parse_tokens => ['fertility_rate'], :socrata_id => 'g5zk-9ycw', :url => 'https://data.cityofchicago.org/Health-Human-Services/Public-Health-Statistics-General-fertility-rates-i/g5zk-9ycw', :description => "Annual general fertility rate (births per 1,000 females aged 15-44 years) with corresponding 95% confidence intervals, by Chicago community area, for the years 1999 - 2009.", :stat_type => 'rate'},
          {:category => 'Births', :name => 'Percent of Low Weight Births', :parse_tokens => ['percent'], :socrata_id => 'fbxr-9u99', :url => 'https://data.cityofchicago.org/Health-Human-Services/Public-Health-Statistics-Low-birth-weight-in-Chica/fbxr-9u99', :description => "Percent of total births that were low birth weight with corresponding 95% confidence intervals, by Chicago community area, for the years 1999 - 2009.", :stat_type => 'percent'},
          {:category => 'Births', :name => 'Percent of Preterm Births', :parse_tokens => ['percent'], :socrata_id => 'rhy3-4x2f', :url => 'https://data.cityofchicago.org/Health-Human-Services/Public-Health-Statistics-Preterm-births-in-Chicago/rhy3-4x2f', :description => "Percent of total births these preterm births represent, with corresponding 95% confidence intervals, by Chicago community area, for the years 1999 - 2009.", :stat_type => 'percent'},
          {:category => 'Births', :name => 'Teen Birth Rate', :parse_tokens => ['teen_birth_rate'], :socrata_id => '9kva-bt6k', :url => 'https://data.cityofchicago.org/Health-Human-Services/Public-Health-Statistics-Births-to-mothers-aged-15/9kva-bt6k', :description => "Annual birth rate (births per 1,000 females aged 15-19 years) with corresponding 95% confidence intervals, by Chicago community area, for the years 1999 - 2009.", :stat_type => 'rate'},
  
          # special case: blown up rows for 1ST TRIMESTER, 2ND TRIMESTER, 3RD TRIMESTER, NO PRENATAL CARE, NOT GIVEN
          {:category => 'Births', :name => 'Prenatal Care Obtained in 1st Trimester', :group_column => 'trimester_prenatal_care_began', :groups => ['1ST TRIMESTER'], :parse_tokens => ['percent'], :socrata_id => '2q9j-hh6g', :url => 'https://data.cityofchicago.org/Health-Human-Services/Public-Health-Statistics-Prenatal-care-in-Chicago-/2q9j-hh6g', :description => "Percent of live births in which the mother began prenatal care during the 1st trimester with corresponding 95% confidence intervals, by Chicago community area, for the years 1999 - 2009.", :stat_type => 'percent'},
          
          # Deaths
          {:category => 'Deaths', :name => 'Infant mortality', :parse_tokens => ['average_infant_mortality_rate_2005__2009'], :socrata_id => 'bfhr-4ckq', :url => 'https://data.cityofchicago.org/Health-Human-Services/Public-Health-Statistics-Infant-mortality-in-Chica/bfhr-4ckq', :description => "Average annual infant mortality rate, by Chicago community area, for the years 2005 - 2009.", :stat_type => 'range, rate', :range => '2005 - 2009'},
  
          # special case: broken down by death cause
          # causes: All causes, All causes in females,All causes in males,Alzheimers disease,Assault (homicide),Breast cancer in females,Cancer (all sites),Colorectal cancer,Coronary heart disease,Diabetes-related,Firearm-related,Injury, unintentional,Kidney disease (nephritis, nephrotic syndrome and nephrosis),Liver disease and cirrhosis,Lung cancer,Prostate cancer in males,Stroke (cerebrovascular disease),Suicide (intentional self-harm)
          
          {:category => 'Deaths', :name => 'All causes', :group_column => 'cause_of_death', :groups => ['All causes'], :parse_tokens => ['average_adjusted_rate_2005__2009'], :socrata_id => 'j6cj-r444', :url => 'https://data.cityofchicago.org/Health-Human-Services/Public-Health-Statistics-Selected-underlying-cause/j6cj-r444', :description => "Adjusted death rates per 100,000 residents from all causes by Chicago community area from 2005 - 2009" , :stat_type => 'range, rate', :range => '2005 - 2009'},
          {:category => 'Deaths', :name => 'All causes in females', :group_column => 'cause_of_death', :groups => ['All causes in females'], :parse_tokens => ['average_adjusted_rate_2005__2009'], :socrata_id => 'j6cj-r444', :url => 'https://data.cityofchicago.org/Health-Human-Services/Public-Health-Statistics-Selected-underlying-cause/j6cj-r444', :description => "Adjusted death rates per 100,000 residents from all causes in females by Chicago community area from 2005 - 2009" , :stat_type => 'range, rate', :range => '2005 - 2009'},
          {:category => 'Deaths', :name => 'All causes in males', :group_column => 'cause_of_death', :groups => ['All causes in males'], :parse_tokens => ['average_adjusted_rate_2005__2009'], :socrata_id => 'j6cj-r444', :url => 'https://data.cityofchicago.org/Health-Human-Services/Public-Health-Statistics-Selected-underlying-cause/j6cj-r444', :description => "Adjusted death rates per 100,000 residents from all causes in males by Chicago community area from 2005 - 2009" , :stat_type => 'range, rate', :range => '2005 - 2009'},
          {:category => 'Deaths', :name => 'Alzheimers disease', :group_column => 'cause_of_death', :groups => ['Alzheimers disease'], :parse_tokens => ['average_adjusted_rate_2005__2009'], :socrata_id => 'j6cj-r444', :url => 'https://data.cityofchicago.org/Health-Human-Services/Public-Health-Statistics-Selected-underlying-cause/j6cj-r444', :description => "Adjusted death rates per 100,000 residents from Alzheimers disease by Chicago community area from 2005 - 2009" , :stat_type => 'range, rate', :range => '2005 - 2009'},
          {:category => 'Deaths', :name => 'Assault (homicide)', :group_column => 'cause_of_death', :groups => ['Assault (homicide)'], :parse_tokens => ['average_adjusted_rate_2005__2009'], :socrata_id => 'j6cj-r444', :url => 'https://data.cityofchicago.org/Health-Human-Services/Public-Health-Statistics-Selected-underlying-cause/j6cj-r444', :description => "Adjusted death rates per 100,000 residents from Assault (homicide) by Chicago community area from 2005 - 2009" , :stat_type => 'range, rate', :range => '2005 - 2009'},
          {:category => 'Deaths', :name => 'Breast cancer in females', :group_column => 'cause_of_death', :groups => ['Breast cancer in females'], :parse_tokens => ['average_adjusted_rate_2005__2009'], :socrata_id => 'j6cj-r444', :url => 'https://data.cityofchicago.org/Health-Human-Services/Public-Health-Statistics-Selected-underlying-cause/j6cj-r444', :description => "Adjusted death rates per 100,000 residents from breast cancer in females by Chicago community area from 2005 - 2009" , :stat_type => 'range, rate', :range => '2005 - 2009'},
          {:category => 'Deaths', :name => 'Cancer (all sites)', :group_column => 'cause_of_death', :groups => ['Cancer (all sites)'], :parse_tokens => ['average_adjusted_rate_2005__2009'], :socrata_id => 'j6cj-r444', :url => 'https://data.cityofchicago.org/Health-Human-Services/Public-Health-Statistics-Selected-underlying-cause/j6cj-r444', :description => "Adjusted death rates per 100,000 residents from cancer (all sites) by Chicago community area from 2005 - 2009" , :stat_type => 'range, rate', :range => '2005 - 2009'},
          {:category => 'Deaths', :name => 'Colorectal cancer', :group_column => 'cause_of_death', :groups => ['Colorectal cancer'], :parse_tokens => ['average_adjusted_rate_2005__2009'], :socrata_id => 'j6cj-r444', :url => 'https://data.cityofchicago.org/Health-Human-Services/Public-Health-Statistics-Selected-underlying-cause/j6cj-r444', :description => "Adjusted death rates per 100,000 residents from colorectal cancer by Chicago community area from 2005 - 2009" , :stat_type => 'range, rate', :range => '2005 - 2009'},
          {:category => 'Deaths', :name => 'Coronary heart disease', :group_column => 'cause_of_death', :groups => ['Coronary heart disease'], :parse_tokens => ['average_adjusted_rate_2005__2009'], :socrata_id => 'j6cj-r444', :url => 'https://data.cityofchicago.org/Health-Human-Services/Public-Health-Statistics-Selected-underlying-cause/j6cj-r444', :description => "Adjusted death rates per 100,000 residents from coronary heart disease by Chicago community area from 2005 - 2009" , :stat_type => 'range, rate', :range => '2005 - 2009'},
          {:category => 'Deaths', :name => 'Diabetes-related', :group_column => 'cause_of_death', :groups => ['Diabetes-related'], :parse_tokens => ['average_adjusted_rate_2005__2009'], :socrata_id => 'j6cj-r444', :url => 'https://data.cityofchicago.org/Health-Human-Services/Public-Health-Statistics-Selected-underlying-cause/j6cj-r444', :description => "Adjusted diabetes-related death rates per 100,000 residents by Chicago community area from 2005 - 2009" , :stat_type => 'range, rate', :range => '2005 - 2009'},
          {:category => 'Deaths', :name => 'Firearm-related', :group_column => 'cause_of_death', :groups => ['Firearm-related'], :parse_tokens => ['average_adjusted_rate_2005__2009'], :socrata_id => 'j6cj-r444', :url => 'https://data.cityofchicago.org/Health-Human-Services/Public-Health-Statistics-Selected-underlying-cause/j6cj-r444', :description => "Adjusted firearm-related death rates per 100,000 residents by Chicago community area from 2005 - 2009" , :stat_type => 'range, rate', :range => '2005 - 2009'},
          {:category => 'Deaths', :name => 'Injury, unintentional', :group_column => 'cause_of_death', :groups => ['Injury,unintentional'], :parse_tokens => ['average_adjusted_rate_2005__2009'], :socrata_id => 'j6cj-r444', :url => 'https://data.cityofchicago.org/Health-Human-Services/Public-Health-Statistics-Selected-underlying-cause/j6cj-r444', :description => "Adjusted death rates per 100,000 residents from unintentional injury by Chicago community area from 2005 - 2009" , :stat_type => 'range, rate', :range => '2005 - 2009'},
          {:category => 'Deaths', :name => 'Kidney disease', :group_column => 'cause_of_death', :groups => ['Kidney disease (nephritis,nephrotic syndrome and nephrosis)'], :parse_tokens => ['average_adjusted_rate_2005__2009'], :socrata_id => 'j6cj-r444', :url => 'https://data.cityofchicago.org/Health-Human-Services/Public-Health-Statistics-Selected-underlying-cause/j6cj-r444', :description => "Adjusted death rates per 100,000 residents from kidney disease (nephritis, nephrotic syndrome and nephrosis) by Chicago community area from 2005 - 2009" , :stat_type => 'range, rate', :range => '2005 - 2009'},
          {:category => 'Deaths', :name => 'Liver disease and cirrhosis', :group_column => 'cause_of_death', :groups => ['Liver disease and cirrhosis'], :parse_tokens => ['average_adjusted_rate_2005__2009'], :socrata_id => 'j6cj-r444', :url => 'https://data.cityofchicago.org/Health-Human-Services/Public-Health-Statistics-Selected-underlying-cause/j6cj-r444', :description => "Adjusted death rates per 100,000 residents from liver disease and cirrhosis by Chicago community area from 2005 - 2009" , :stat_type => 'range, rate', :range => '2005 - 2009'},
          {:category => 'Deaths', :name => 'Lung cancer', :group_column => 'cause_of_death', :groups => ['Lung cancer'], :parse_tokens => ['average_adjusted_rate_2005__2009'], :socrata_id => 'j6cj-r444', :url => 'https://data.cityofchicago.org/Health-Human-Services/Public-Health-Statistics-Selected-underlying-cause/j6cj-r444', :description => "Adjusted death rates per 100,000 residents from lung cancer by Chicago community area from 2005 - 2009" , :stat_type => 'range, rate', :range => '2005 - 2009'},
          {:category => 'Deaths', :name => 'Prostate cancer in males', :group_column => 'cause_of_death', :groups => ['Prostate cancer in males'], :parse_tokens => ['average_adjusted_rate_2005__2009'], :socrata_id => 'j6cj-r444', :url => 'https://data.cityofchicago.org/Health-Human-Services/Public-Health-Statistics-Selected-underlying-cause/j6cj-r444', :description => "Adjusted death rates per 100,000 residents from prostate cancer in males by Chicago community area from 2005 - 2009" , :stat_type => 'range, rate', :range => '2005 - 2009'},
          {:category => 'Deaths', :name => 'Stroke', :group_column => 'cause_of_death', :groups => ['Stroke (cerebrovascular disease)'], :parse_tokens => ['average_adjusted_rate_2005__2009'], :socrata_id => 'j6cj-r444', :url => 'https://data.cityofchicago.org/Health-Human-Services/Public-Health-Statistics-Selected-underlying-cause/j6cj-r444', :description => "Adjusted death rates per 100,000 residents from stroke (cerebrovascular disease) by Chicago community area from 2005 - 2009" , :stat_type => 'range, rate', :range => '2005 - 2009'},
          {:category => 'Deaths', :name => 'Suicide', :group_column => 'cause_of_death', :groups => ['Suicide (intentional self-harm)'], :parse_tokens => ['average_adjusted_rate_2005__2009'], :socrata_id => 'j6cj-r444', :url => 'https://data.cityofchicago.org/Health-Human-Services/Public-Health-Statistics-Selected-underlying-cause/j6cj-r444', :description => "Adjusted death rates per 100,000 residents from suicide (intentional self-harm) by Chicago community area from 2005 - 2009" , :stat_type => 'range, rate', :range => '2005 - 2009'},
        
          # Environmental Health
          {:category => 'Environmental Health', :name => 'Lead Screening Rate', :parse_tokens => ['lead_screening_rate'], :socrata_id => 'v2z5-jyrq', :url => 'https://data.cityofchicago.org/Health-Human-Services/Public-Health-Statistics-Screening-for-elevated-bl/v2z5-jyrq', :description => "Estimated rate per 1,000 children aged 0-6 years receiving a blood lead level test, by Chicago community area, for the years 1999 - 2011.", :stat_type => 'rate'},
          {:category => 'Environmental Health', :name => 'Elevated Blood Lead Levels', :parse_tokens => ['percent_elevated'], :socrata_id => 'v2z5-jyrq', :url => 'https://data.cityofchicago.org/Health-Human-Services/Public-Health-Statistics-Screening-for-elevated-bl/v2z5-jyrq', :description => "Estimated percentage of children aged 0-6 years tested found to have an elevated blood lead level with corresponding 95% confidence intervals, by Chicago community area, for the years 1999 - 2011.", :stat_type => 'percent'},
          
          # Infectious disease
          {:category => 'Infectious Disease', :name => 'Tuberculosis', :parse_tokens => ['average_annual_incidence_rate_20072011'], :socrata_id => 'ndk3-zftj', :url => 'https://data.cityofchicago.org/Health-Human-Services/Public-Health-Statistics-Tuberculosis-cases-and-av/ndk3-zftj', :description => "Annual number of new cases of tuberculosis by Chicago community area, for the years 2007 - 2011.", :stat_type => 'range, count', :range => '2007 - 2011'},
          {:category => 'Infectious Disease', :name => 'Gonorrhea in females', :parse_tokens => ['incidence_rate'], :socrata_id => 'cgjw-mn43', :url => 'https://data.cityofchicago.org/Health-Human-Services/Public-Health-Statistics-Gonorrhea-cases-for-femal/cgjw-mn43', :description => "Annual number of newly reported, laboratory-confirmed cases of gonorrhea (Neisseria gonorrhoeae) among females aged 15-44 years and annual gonorrhea incidence rate (cases per 100,000 females aged 15-44 years) with corresponding 95% confidence intervals by Chicago community area, for years 2000 - 2011.", :stat_type => 'rate'},
          {:category => 'Infectious Disease', :name => 'Gonorrhea in males', :parse_tokens => ['incidence_rate'], :socrata_id => 'm5qn-gmjx', :url => 'https://data.cityofchicago.org/Health-Human-Services/Public-health-statistics-Gonorrhea-cases-for-males/m5qn-gmjx', :description => "Annual number of newly reported, laboratory-confirmed cases of gonorrhea (Neisseria gonorrhoeae) among males aged 15-44 years and annual gonorrhea incidence rate (cases per 100,000 males aged 15-44 years) with corresponding 95% confidence intervals by Chicago community area, for years 2000 - 2011. ", :stat_type => 'rate'},
          {:category => 'Infectious Disease', :name => 'Chlamydia in females', :parse_tokens => ['incidence_rate'], :socrata_id => 'bz6k-73ti', :url => 'https://data.cityofchicago.org/Health-Human-Services/Public-Health-Statistics-Chlamydia-cases-among-fem/bz6k-73ti', :description => "Annual number of newly reported, laboratory-confirmed cases of chlamydia (Chlamydia trachomatis) among females aged 15-44 years and annual chlamydia incidence rate (cases per 100,000 females aged 15-44 years) with corresponding 95% confidence intervals by Chicago community area, for years 2000 - 2011. ", :stat_type => 'rate'},
  
          # Chronic disease
          # these are aggregated by zip code
          {:category => 'Chronic Disease', :name => 'Diabetes Hospitalizations', :parse_tokens => ['crude_rate'], :socrata_id => 'vekt-28b5', :url => 'https://data.cityofchicago.org/Health-Human-Services/Public-Health-Statistics-Diabetes-hospitalizations/vekt-28b5', :description => "Age-adjusted hospitalization rates with corresponding 95% confidence intervals, for the years 2000 - 2011, by Chicago U.S. Postal Service ZIP code or ZIP code aggregate.", :stat_type => 'rate', :area => 'zip'},
          {:category => 'Chronic Disease', :name => 'Asthma Hospitalizations', :parse_tokens => ['crude_rate'], :socrata_id => 'vazh-t57q', :url => 'https://data.cityofchicago.org/Health-Human-Services/Public-Health-Statistics-Asthma-hospitalizations-i/vazh-t57q', :description => "Age-adjusted hospitalization rates (per 10,000 children and adults aged 5 to 64 years) with corresponding 95% confidence intervals, for the years 2000 - 2011, by Chicago U.S. Postal Service ZIP code or ZIP code aggregate.", :stat_type => 'rate', :area => 'zip'},
  
          # Demographic
          {:category => 'Demographics', :name => 'Below Poverty Level', :parse_tokens => ['below_poverty_level'], :range => '2007-2011', :socrata_id => 'iqnk-2tcu', :url => 'https://data.cityofchicago.org/Health-Human-Services/Public-Health-Statistics-Selected-public-health-in/iqnk-2tcu', :description => "Percent of households under the poverty level for the years 2007-2011.", :stat_type => 'range, percent'},
          {:category => 'Demographics', :name => 'Crowded Housing', :parse_tokens => ['crowded_housing'], :range => '2007-2011', :socrata_id => 'iqnk-2tcu', :url => 'https://data.cityofchicago.org/Health-Human-Services/Public-Health-Statistics-Selected-public-health-in/iqnk-2tcu', :description => "Percent of occupied crowded housing units for the years 2007-2011.", :stat_type => 'range, percent'},
          {:category => 'Demographics', :name => 'Dependency', :parse_tokens => ['dependency'], :range => '2007-2011', :socrata_id => 'iqnk-2tcu', :url => 'https://data.cityofchicago.org/Health-Human-Services/Public-Health-Statistics-Selected-public-health-in/iqnk-2tcu', :description => "Percent of persons aged less than 16 or more than 64 years for the years 2007-2011.", :stat_type => 'range, percent'},
          {:category => 'Demographics', :name => 'No High School Diploma', :parse_tokens => ['no_high_school_diploma'], :range => '2007-2011', :socrata_id => 'iqnk-2tcu', :url => 'https://data.cityofchicago.org/Health-Human-Services/Public-Health-Statistics-Selected-public-health-in/iqnk-2tcu', :description => "Percent of persons aged 25 years and older with no high school diploma for the years 2007-2011.", :stat_type => 'range, percent'},
          {:category => 'Demographics', :name => 'Per capita income', :parse_tokens => ['per_capita_income'], :range => '2007-2011', :socrata_id => 'iqnk-2tcu', :url => 'https://data.cityofchicago.org/Health-Human-Services/Public-Health-Statistics-Selected-public-health-in/iqnk-2tcu', :description => "2011 inflation-adjusted dollars of annual income per person for the years 2007-2011", :stat_type => 'range, money'},
          {:category => 'Demographics', :name => 'Unemployment', :parse_tokens => ['unemployment'], :range => '2007-2011', :socrata_id => 'iqnk-2tcu', :url => 'https://data.cityofchicago.org/Health-Human-Services/Public-Health-Statistics-Selected-public-health-in/iqnk-2tcu', :description => "Percent of persons in labor force aged 16 years and older for the years 2007-2011", :stat_type => 'range, percent'},
  
        ]
  
        datasets.each do |d|
          handle = "#{d[:category]} #{d[:name]}".parameterize.underscore.to_sym
          
          puts "downloading '#{d[:name]}'"
          sh "curl -o tmp/#{handle}.csv https://data.cityofchicago.org/api/views/#{d[:socrata_id]}/rows.csv?accessType=DOWNLOAD"
        
          csv_text = File.read("tmp/#{handle}.csv")
          csv_text = csv_text.gsub(', ', ',') # hack to remove leading spaces in column headers
  
          csv = CSV.parse(csv_text, {:headers => true, :header_converters => :symbol})
          # puts csv.first.inspect
  
          d[:parse_tokens].each do |parse_token|
  
            if d.has_key?(:group_column) and d.has_key?(:groups)
              puts "unpacking groups based on '#{d[:group_column]}' column"
              d[:groups].each do |group|
                # save each data portal set, parse_token and group combination as a separate dataset
                dataset = save_cdph_dataset(d, parse_token, handle, group)
  
                csv.each do |row|
                  process_cdph_row(d, row, dataset, parse_token, d[:group_column], group)
                end
  
                stat_count = Statistic.count(:conditions => "dataset_id = #{dataset.id}")
                puts "#{parse_token}, #{group}: imported #{stat_count} statistics"
              end
            else
              # save each data portal set and parse_token combination as a separate dataset
              dataset = save_cdph_dataset(d, parse_token, handle)
  
              csv.each do |row|
                process_cdph_row(d, row, dataset, parse_token)
              end
  
              stat_count = Statistic.count(:conditions => "dataset_id = #{dataset.id}")
              puts "#{parse_token}: imported #{stat_count} statistics"
            end
          end
        end
  
        # manually import demographics for Chicago. Source PDF: https://data.cityofchicago.org/api/assets/2107948F-357D-4ED7-ACC2-2E9266BBFFA2
        puts 'manually importing Chicago CDPH demographics'
        chicago_demographics = {
          'below_poverty_level' => 19, 
          'crowded_housing' => 4.7, 
          'dependency' => 33.8, 
          'no_high_school_diploma' => 19.8, 
          'per_capita_income' => 27940, 
          'unemployment' => 12
        }
  
        chicago_demographics.each do |key,value|
          dset_id = Dataset.where("slug = 'demographics_#{key}'").first.id
  
          stat = Statistic.new(
            :dataset_id => dset_id,
            :geography_id => 100,
            :year => 2007,
            :year_range => '2007-2011',
            :name => key, 
            :value => value
          )
          stat.save!
        end
  
        puts 'Done!'
      end
  
      def save_cdph_dataset(d, parse_token, handle, group='')
  
        data_type = 'condition'
        if d[:category] == "Demographics"
          data_type = 'demographics'
        end
  
        dataset = Dataset.new(
          :name => d[:name],
          :slug => "#{handle}",
          :description => '', # leaving blank for now
          :provider => 'Chicago Department of Public Health',
          :url => d[:url],
          :category_id => Category.where(:name => d[:category]).first.id,
          :data_type => data_type,
          :description => d[:description],
          :stat_type => d[:stat_type]
        )
  
        dataset.save!
        dataset
      end
  
      def process_cdph_row(d, row, dataset, parse_token, group_column='', group='')
        row = row.to_hash.with_indifferent_access
  
        area = ''
        if (d.has_key?(:area) and d[:area] == 'zip')
          area = row['zip_code_or_aggregate']
        else
          # sometimes Community Area is named differently
          area = row['community_area']
          if area.nil? || area == ''
            area = row['community_area_number']
          end
        end
  
        area = get_area_id(area)
  
        if group != '' and group_column != ''
          if row[group_column] == group
            save_cdph_statistic(d, row, dataset, area, parse_token)
          end
        else
          save_cdph_statistic(d, row, dataset, area, parse_token)
        end
      end

      def save_cdph_statistic(d, row, dataset, area, parse_token)

        if d.has_key?(:range)
          stat = Statistic.new(
            :dataset_id => dataset.id,
            :geography_id => area,
            :year => d[:range][0..3], # pluck out the first year in the range
            :year_range => d[:range],
            :name => parse_token, 
            :value => row["#{parse_token}"]
          )

          if (row.has_key?("#{parse_token}_lower_ci"))
            stat.lower_ci = row["#{parse_token}_lower_ci"]
          end

          if (row.has_key?("#{parse_token}_upper_ci"))
            stat.upper_ci = row["#{parse_token}_upper_ci"]
          end

          stat.save!
          stat
        else
          (1999..Time.now.year).each do |year|
            if (row.has_key?("#{parse_token}_#{year}"))
              stat = Statistic.new(
                :dataset_id => dataset.id,
                :geography_id => area,
                :year => year,
                :name => parse_token, 
                :value => row["#{parse_token}_#{year}"]
              )

              if (row.has_key?("#{parse_token}_#{year}_lower_ci"))
                stat.lower_ci = row["#{parse_token}_#{year}_lower_ci"]
              end

              if (row.has_key?("#{parse_token}_#{year}_upper_ci"))
                stat.upper_ci = row["#{parse_token}_#{year}_upper_ci"]
              end

              stat.save!
              stat
            end
          end
        end
      end

      def get_area_id(area)
        if area == '60601,60602,60603,60604,60605 & 60611'
          area = '12311'
        elsif area == '60606,60607 & 60661'
          area = '6761'
        elsif area == '60622 & 60642'
          area = '60622'
        elsif area == '60610 & 60654'
          area = '60610'
        elsif area == 'CHICAGO' or area == 'CH' or area == '0' or area == '88'
          area = '100' # Chicago is manually imported, see seeds.rb
        end
        area
      end

      desc "Import Chicago homicide, assault, and battery from Socrata"
      task :crime => :environment do

        Dataset.where(:provider => "Chicago Police Department").each do |d|
          Statistic.delete_all(:dataset_id => d.id)
          d.delete
        end

        start_year = 2003 # 2001 and 2002 are years with incomplete data
        datasets = [
          {:category => 'Crime', :name => 'Homicide', :fbi_code => "01A", :parse_token => 'crime-h', :description => "Number of reported homicides per 1,000 residents from 2003 - 2013", :stat_type => 'rate'},
          {:category => 'Crime', :name => 'Aggravated Assault', :fbi_code => "04A", :parse_token => 'crime-aa', :description => "Number of reported aggravated assaults per 1,000 residents from 2003 - 2013", :stat_type => 'rate'},
          {:category => 'Crime', :name => 'Simple Assault', :fbi_code => "08A", :parse_token => 'crime-sa', :description => "Number of reported simple assaults per 1,000 residents from 2003 - 2013", :stat_type => 'rate'},
          {:category => 'Crime', :name => 'Aggravated Battery', :fbi_code => "04B", :parse_token => 'crime-ab', :description => "Number of reports of aggravated battery per 1,000 residents from 2003 - 2013", :stat_type => 'rate'},
          {:category => 'Crime', :name => 'Simple Battery', :fbi_code => "08B", :parse_token => 'crime-sb', :description => "Number of reports of simple battery per 1,000 residents from 2003 - 2013", :stat_type => 'rate'}
        ]

        datasets.each do |d|
          handle = "#{d[:category]} #{d[:name]}".parameterize.underscore.to_sym

          dataset = Dataset.new(
            :name => d[:name],
            :slug => handle,
            :description => d[:description],
            :provider => 'Chicago Police Department',
            :url => d[:url],
            :category_id => Category.where(:name => d[:category]).first.id,
            :data_type => 'condition',
            :description => d[:description],
            :stat_type => d[:stat_type]
          )

          dataset.save!

          found_stats = { }
          last_year = Time.now.year - 1

          puts "Downloading #{handle}.json"
          sh "curl -o tmp/#{handle}.json 'https://data.cityofchicago.org/resource/ijzp-q8t2.json?$select=community_area,year,count%28id%29&$where=fbi_code=%27#{d[:fbi_code]}%27&$group=community_area,year,fbi_code'"
          json_text = File.read("tmp/#{handle}.json")
          stats = ActiveSupport::JSON.decode( json_text )
          stats.each do |stat|
            if (stat['year'].to_i < start_year) or (stat['year'].to_i > last_year)
              # skip incomplete years
              next
            end
            if stat['community_area'].nil? or stat['community_area'] == ' ' or stat['community_area'] == ' 0'  or stat['community_area'] == '0'
              next
            end

            # adjust count by community area population
            if (stat['year'].to_i > 2010)
              # until the 2020 census, we'll have to go on 2010 population
              comm_population = Geography.find(stat['community_area']).population(2010)
            else
              comm_population = Geography.find(stat['community_area']).population(stat['year'])
            end

            crime_count = stat['count_id'].to_f or 0
            crime_rate = crime_count / (comm_population / 1000.0)  # rate per 1000 residents

            store = Statistic.new(
              :dataset_id => dataset.id,
              :geography_id => stat['community_area'],
              :year => stat['year'],
              :name => d[:parse_token],
              :value => ('%.2f' % crime_rate) # rounded to 2 decimal places
            )
            store.save!

            if found_stats.has_key?( "area" + stat['community_area'] )
              found_stats[ "area" + stat['community_area'] ] << stat['year'].to_i
            else
              found_stats[ "area" + stat['community_area'] ] = [ stat['year'].to_i ]
            end

          end

          found_stats.each do |community_area, year|
            (start_year .. last_year).each do |year| 
              if found_stats[community_area].index(year).nil?
                # add a zero
                store = Statistic.new(
                  :dataset_id => dataset.id,
                  :geography_id => community_area.gsub("area",""),
                  :year => year,
                  :name => d[:parse_token],
                  :value => 0
                )
                store.save!
              end
            end
          end

          puts "Saving #{d[:name]} crime stats for Chicago"

          puts "Downloading #{handle}_chicago.json"
          sh "curl -o tmp/#{handle}_chicago.json 'https://data.cityofchicago.org/resource/ijzp-q8t2.json?$select=year,count%28id%29&$where=fbi_code=%27#{d[:fbi_code]}%27&$group=year,fbi_code'"
          json_text = File.read("tmp/#{handle}_chicago.json")
          stats = ActiveSupport::JSON.decode( json_text )
          stats.each do |stat|
            if (stat['year'].to_i < start_year) or (stat['year'].to_i > last_year)
              # skip incomplete years
              next
            end

            # adjust count by city population
            if (stat['year'].to_i > 2010)
              # until the 2020 census, we'll have to go on 2010 population
              chicago_population = Geography.find(100).population(2010)
            else
              chicago_population = Geography.find(100).population(stat['year'])
            end

            chicago_crime_rate = stat['count_id'].to_f / (chicago_population / 1000.0)  # rate per 100,000 residents

            store = Statistic.new(
              :dataset_id => dataset.id,
              :geography_id => 100,
              :year => stat['year'],
              :name => d[:parse_token],
              :value => ('%.2f' % chicago_crime_rate) # rounded to 2 decimal places
            )
            store.save!
          end

        end
        puts 'Done!'
      end
    
    end
  end
end