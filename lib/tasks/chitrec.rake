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

        datasets = [
          # Breast_cancer,Colorectal_cancer,Prostate_cancer,Lung_cancer,Diabetes,HTN,Asthma,COPD,CHD
          {:category => 'Chronic disease', :name => 'Breast cancer', :parse_token => 'breast_cancer', :description => "Estimated Breast Cancer prevalence in Chicago for adults aged 18-89 based on aggregated Electronic Health Record (EHR) data from a selection of healthcare institutions from 2006 through 2010.", :stat_type => 'range, percent'},
          {:category => 'Chronic disease', :name => 'Colorectal cancer', :parse_token => 'colorectal_cancer', :description => "Estimated Colorectal Cancer prevalence in Chicago for adults aged 18-89 based on aggregated Electronic Health Record (EHR) data from a selection of healthcare institutions from 2006 through 2010.", :stat_type => 'range, percent'},
          {:category => 'Chronic disease', :name => 'Prostate cancer', :parse_token => 'prostate_cancer', :description => "Estimated Prostate Cancer prevalence in Chicago for adults aged 18-89 based on aggregated Electronic Health Record (EHR) data from a selection of healthcare institutions from 2006 through 2010.", :stat_type => 'range, percent'},
          {:category => 'Chronic disease', :name => 'Lung cancer', :parse_token => 'lung_cancer', :description => "Estimated Lung Cancer prevalence in Chicago for adults aged 18-89 based on aggregated Electronic Health Record (EHR) data from a selection of healthcare institutions from 2006 through 2010.", :stat_type => 'range, percent'},
          {:category => 'Chronic disease', :name => 'Diabetes', :parse_token => 'diabetes', :description => "Estimated diabetes prevalence in Chicago for adults aged 18-89 based on aggregated Electronic Health Record (EHR) data from a selection of healthcare institutions from 2006 through 2010.", :stat_type => 'range, percent'},
          {:category => 'Chronic disease', :name => 'Hypertension', :parse_token => 'htn', :description => "Estimated hypertension prevalence in Chicago for adults aged 18-89 based on aggregated Electronic Health Record (EHR) data from a selection of healthcare institutions from 2006 through 2010.", :stat_type => 'range, percent'},
          {:category => 'Chronic disease', :name => 'Asthma', :parse_token => 'asthma', :description => "Estimated asthma prevalence in Chicago for adults aged 18-89 based on aggregated Electronic Health Record (EHR) data from a selection of healthcare institutions from 2006 through 2010.", :stat_type => 'range, percent'},
          {:category => 'Chronic disease', :name => 'Chronic Obstructive Pulmonary Disease', :parse_token => 'copd', :description => "Estimated Chronic Obstructive Pulmonary Disease (COPD) prevalence in Chicago for adults aged 18-89 based on aggregated Electronic Health Record (EHR) data from a selection of healthcare institutions from 2006 through 2010.", :stat_type => 'range, percent'},
          {:category => 'Chronic disease', :name => 'Congestive Heart Failure', :parse_token => 'chd', :description => "Estimated Congestive Heart Failure (CHF) prevalence in Chicago for adults aged 18-89 based on aggregated Electronic Health Record (EHR) data from a selection of healthcare institutions from 2006 through 2010.", :stat_type => 'range, percent'},
        ]

        csv_text = File.read("db/import/chitrec_data_2006-2010.csv")
        csv = CSV.parse(csv_text, {:headers => true, :header_converters => :symbol})

        datasets.each do |d|
          handle = "#{d[:category]} #{d[:name]}".parameterize.underscore.to_sym

          dataset = Dataset.new(
            :name => d[:name],
            :slug => handle,
            :description => d[:description],
            :provider => 'CHITREC',
            :url => "https://raw.githubusercontent.com/smartchicago/chicago-atlas/master/db/import/chitrec_data_2006-2012.csv",
            :category_id => Category.where(:name => d[:category]).first.id,
            :data_type => 'condition',
            :description => d[:description],
            :stat_type => d[:stat_type]
          )

          dataset.save!

          chicago_numerator = 0
          chicago_denominator = 0

          csv.each do |row|
            row = row.to_hash.with_indifferent_access

            numerator = row[d[:parse_token]]
            denominator = row['count']

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
              :year_range => '2006 - 2010',
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
            :year_range => '2006 - 2010',
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