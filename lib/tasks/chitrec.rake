namespace :db do
  namespace :import do
    namespace :chitrec do

      desc "Import CHITREC datasets from csv"
      task :all => :environment do
        require 'csv' 

        Dataset.where(:provider => "CHITREC").each do |d|
          Statistic.delete_all(:dataset_id => d.id)
          d.delete
        end

        ######## make changes here when updating chitrec data ########
        chitrec_category = 'Chronic Disease'
        chitrec_year_range = '2006 - 2012'
        chitrec_desc_start = "Estimated"
        chitrec_desc_end = 'prevalence in Chicago for adults aged 18-89 based on aggregated Electronic Health Record (EHR) data from a selection of healthcare institutions from 2006 through 2012.'
        chitrec_raw_file = 'db/import/chitrec_data_2006-2012.csv'
        chitrec_url = 'https://raw.githubusercontent.com/smartchicago/chicago-atlas/master/db/import/chitrec_data_2006-2012.csv'
        ##############################################################

        datasets = [
          # Breast_cancer,Colorectal_cancer,Prostate_cancer,Lung_cancer,Diabetes,HTN,Asthma,COPD,CHD
          {:name => 'Breast cancer', :parse_token => 'breast_cancer', :description => "breast cancer", :stat_type => 'range, percent'},
          {:name => 'Colorectal cancer', :parse_token => 'colorectal_cancer', :description => "colorectal cancer", :stat_type => 'range, percent'},
          {:name => 'Prostate cancer', :parse_token => 'prostate_cancer', :description => "prostate cancer", :stat_type => 'range, percent'},
          {:name => 'Lung cancer', :parse_token => 'lung_cancer', :description => "lung cancer", :stat_type => 'range, percent'},
          {:name => 'Diabetes', :parse_token => 'diabetes', :description => "diabetes", :stat_type => 'range, percent'},
          {:name => 'Hypertension', :parse_token => 'htn', :description => "hypertension", :stat_type => 'range, percent'},
          {:name => 'Asthma', :parse_token => 'asthma', :description => "asthma", :stat_type => 'range, percent'},
          {:name => 'Chronic Obstructive Pulmonary Disease', :parse_token => 'copd', :description => "chronic obstructive pulmonary disease (COPD)", :stat_type => 'range, percent'},
          {:name => 'Congestive Heart Failure', :parse_token => 'chd', :description => "congestive heart failure (CHF)", :stat_type => 'range, percent'},
        ]

        csv_text = File.read( chitrec_raw_file )
        csv = CSV.parse(csv_text, {:headers => true, :header_converters => :symbol})

        datasets.each do |d|
          handle = "#{chitrec_category} #{d[:name]}".parameterize.underscore.to_sym

          dataset = Dataset.new(
            :name => d[:name],
            :slug => handle,
            :description => "#{chitrec_desc_start} #{d[:description]} #{chitrec_desc_end}",
            :provider => 'CHITREC',
            :url => chitrec_url,
            :category_id => Category.where(:name => chitrec_category).first.id,
            :data_type => 'condition',
            :stat_type => d[:stat_type]
          )

          dataset.save!

          chicago_numerator = 0
          chicago_denominator = 0

          csv.each do |row|
            row = row.to_hash.with_indifferent_access

            numerator = row[d[:parse_token]]
            denominator = row['count']

            puts row.inspect
            if (numerator == "NULL")
              val = 0
            else
              val = (100 * Integer(numerator).to_f / Integer(denominator)).round(2)
              chicago_numerator = chicago_numerator + Integer(numerator)
              chicago_denominator = chicago_denominator + Integer(denominator)
            end 

            stat = Statistic.new(
              :dataset_id => dataset.id,
              :geography_id => row['zipcode'],
              :year => 2006,
              :year_range => chitrec_year_range,
              :name => d[:parse_token], 
              :value => val
            )
            stat.save!
          end

          chicago_val = (100 * Integer(chicago_numerator).to_f / Integer(chicago_denominator)).round(2)
          chicago_stat = Statistic.new(
            :dataset_id => dataset.id,
            :geography_id => 100, # hard coded ID for Chicago
            :year => 2006,
            :year_range => chitrec_year_range,
            :name => d[:parse_token], 
            :value => chicago_val
          )
          chicago_stat.save!

          stat_count = Statistic.count(:conditions => "dataset_id = #{dataset.id}")
          puts "#{d[:parse_token]}: imported #{stat_count} statistics"

        end
        puts 'Done!'
      end
    end
  end
end