namespace :db do
  namespace :import do
    namespace :inpatient_outpatient do
        desc "Import inpatient admissions by zip from csv"
        task :inpatient => :environment do
          require 'csv'

          cat = 'Hospital Admissions Inpatient'
          cat_id = Category.where(:name => cat).first.id
          Dataset.where(:category_id => cat_id).each do |d|
            Statistic.delete_all(:dataset_id => d.id)
            d.delete
          end

          datasets = [
            {:name => 'All Admissions', :parse_token => 'Total - All Types', :description => '' , :stat_type => 'rate'},
            {:name => 'Infectious/Parasitic', :parse_token => 'Infectious and Parasitic Diseases', :description => '' , :stat_type => 'rate'},
            {:name => 'Neoplasms', :parse_token => 'Neoplasms', :description => '' , :stat_type => 'rate'},
            {:name => 'Endocrine, Nutritional/Metabolic, Immunity', :parse_token => 'Endocrine, Nutritional and Metabolic Diseases, and Immunity Disorders', :description => '' , :stat_type => 'rate'},
            {:name => 'Blood & Blood-Forming Organs', :parse_token => 'Diseases of the Blood and Blood-Forming Organs', :description => '' , :stat_type => 'rate'},
            {:name => 'Psychotic & Intellectual', :parse_token => 'Psychotic Conditions, Other Psychoses, Disorders, and Intellectual Disabilities', :description => '' , :stat_type => 'rate'},
            {:name => 'Drug/Alcohol Related', :parse_token => 'Alcohol-Induced Disorders, Drug-Induced Disorders, Alcohol or Drug Dependence', :description => '' , :stat_type => 'rate'},
            {:name => 'Nervous & Sensory', :parse_token => 'Diseases of the Nervous System and Sense Organs', :description => '' , :stat_type => 'rate'},
            {:name => 'Circulatory', :parse_token => 'Diseases of the Circulatory System', :description => '' , :stat_type => 'rate'},
            {:name => 'Respiratory', :parse_token => 'Diseases of the Respiratory System', :description => '' , :stat_type => 'rate'},
            {:name => 'Digestive', :parse_token => 'Diseases of the Digestive System', :description => '' , :stat_type => 'rate'},
            {:name => 'Genitourinary', :parse_token => 'Diseases of the Genitourinary System', :description => '' , :stat_type => 'rate'},
            {:name => 'Pregnancy/Childbirth/Puerperium Related', :parse_token => 'Complications of Pregnancy, Childbirth, and the Puerperium', :description => '' , :stat_type => 'rate'},
            {:name => 'Skin & Subcutaneous Tissue', :parse_token => 'Diseases of the Skin and Subcutaneous Tissue', :description => '' , :stat_type => 'rate'},
            {:name => 'Muscoskeletal & Connective Tissue', :parse_token => 'Diseases of the Musculoskeletal System and Connective Tissue', :description => '' , :stat_type => 'rate'},
            {:name => 'Congenital Anomalies', :parse_token => 'Congenital Anomalies', :description => '' , :stat_type => 'rate'},
            {:name => 'Perinatal Period Related', :parse_token => 'Certain Conditions Originating in the Perinatal Period', :description => '' , :stat_type => 'rate'},
            {:name => 'Ill-Defined', :parse_token => 'Symptoms, Signs, and Ill-Defined Conditions', :description => '' , :stat_type => 'rate'},
            {:name => 'Injury & Poisoning', :parse_token => 'Injury and Poisoning', :description => '' , :stat_type => 'rate'},
            {:name => 'Not Coded', :parse_token => 'Not Coded', :description => '' , :stat_type => 'rate'}
          ]

          csv_text = File.read("db/import/inpatient_admissions.csv")
          csv = CSV.parse(csv_text, :headers => true)

          datasets.each do |d|
            handle = "#{cat} #{d[:name]}".parameterize.underscore.to_sym

            dataset = Dataset.new(
              :name => d[:name],
              :slug => handle,
              :description => d[:description],
              :provider => 'Illinois Department of Public Health',
              :url => '',
              :category_id => Category.where(:name => cat).first.id,
              :data_type => 'admissions',
              :description => d[:description],
              :stat_type => d[:stat_type]
            )
            dataset.save!
            puts "Inpatient Dataset: #{handle}"

            csv.each do |row|
              zip_id = get_area_id(row["Location"])
              if row[d[:parse_token]].to_s =~ /\d.*/
                count = row[d[:parse_token]].gsub(",","").to_f
              else
                count = nil
              end
              n = 1000
              year = row["Year"]
              if Geography.where("id = #{zip_id.to_i}").present?
                if Statistic.where("name = 'population' and year = #{year} and geography_id = #{zip_id}").present?
                  pop = Geography.find(zip_id).population(year)
                  if count == nil
                    rate = nil
                  else
                    rate = (count/pop * n).round(1)
                  end
                  statistic = Statistic.new(
                    :dataset_id => Dataset.where("slug = '#{handle}'").first.id,
                    :geography_id => zip_id,
                    :year => year,
                    :name => handle, 
                    :value => rate
                  )
                  statistic.save!
                  puts "importing geography #{zip_id}"
                end
              end
            end
          end
        end

        desc "Import outpatient admissions by zip from csv"
        task :outpatient => :environment do
          require 'csv'

          cat = 'Hospital Admissions Outpatient'
          cat_id = Category.where(:name => cat).first.id
          Dataset.where(:category_id => cat_id).each do |d|
            Statistic.delete_all(:dataset_id => d.id)
            d.delete
          end

          datasets = [
            {:name => 'All Admissions', :parse_token => 'Total - All Types', :description => '' , :stat_type => 'rate'},
            {:name => 'Infectious/Parasitic', :parse_token => 'Infectious and Parasitic Diseases', :description => '' , :stat_type => 'rate'},
            {:name => 'Neoplasms', :parse_token => 'Neoplasms', :description => '' , :stat_type => 'rate'},
            {:name => 'Endocrine, Nutritional/Metabolic, Immunity', :parse_token => 'Endocrine, Nutritional and Metabolic Diseases, and Immunity Disorders', :description => '' , :stat_type => 'rate'},
            {:name => 'Blood & Blood-Forming Organs', :parse_token => 'Diseases of the Blood and Blood-Forming Organs', :description => '' , :stat_type => 'rate'},
            {:name => 'Psychotic & Intellectual', :parse_token => 'Psychotic Conditions, Other Psychoses, Disorders, and Intellectual Disabilities', :description => '' , :stat_type => 'rate'},
            {:name => 'Drug/Alcohol Related', :parse_token => 'Alcohol-Induced Disorders, Drug-Induced Disorders, Alcohol or Drug Dependence', :description => '' , :stat_type => 'rate'},
            {:name => 'Nervous & Sensory', :parse_token => 'Diseases of the Nervous System and Sense Organs', :description => '' , :stat_type => 'rate'},
            {:name => 'Circulatory', :parse_token => 'Diseases of the Circulatory System', :description => '' , :stat_type => 'rate'},
            {:name => 'Respiratory', :parse_token => 'Diseases of the Respiratory System', :description => '' , :stat_type => 'rate'},
            {:name => 'Digestive', :parse_token => 'Diseases of the Digestive System', :description => '' , :stat_type => 'rate'},
            {:name => 'Genitourinary', :parse_token => 'Diseases of the Genitourinary System', :description => '' , :stat_type => 'rate'},
            {:name => 'Pregnancy/Childbirth/Puerperium Related', :parse_token => 'Complications of Pregnancy, Childbirth, and the Puerperium', :description => '' , :stat_type => 'rate'},
            {:name => 'Skin & Subcutaneous Tissue', :parse_token => 'Diseases of the Skin and Subcutaneous Tissue', :description => '' , :stat_type => 'rate'},
            {:name => 'Muscoskeletal & Connective Tissue', :parse_token => 'Diseases of the Musculoskeletal System and Connective Tissue', :description => '' , :stat_type => 'rate'},
            {:name => 'Congenital Anomalies', :parse_token => 'Congenital Anomalies', :description => '' , :stat_type => 'rate'},
            {:name => 'Perinatal Period Related', :parse_token => 'Certain Conditions Originating in the Perinatal Period', :description => '' , :stat_type => 'rate'},
            {:name => 'Ill-Defined', :parse_token => 'Symptoms, Signs, and Ill-Defined Conditions', :description => '' , :stat_type => 'rate'},
            {:name => 'Injury & Poisoning', :parse_token => 'Injury and Poisoning', :description => '' , :stat_type => 'rate'},
            {:name => 'Not Coded', :parse_token => 'Not Coded', :description => '' , :stat_type => 'rate'}
          ]

          csv_text = File.read("db/import/outpatient_admissions.csv")
          csv = CSV.parse(csv_text, :headers => true)

          datasets.each do |d|
            handle = "#{cat} #{d[:name]}".parameterize.underscore.to_sym

            dataset = Dataset.new(
              :name => d[:name],
              :slug => handle,
              :description => d[:description],
              :provider => 'Illinois Department of Public Health',
              :url => '',
              :category_id => Category.where(:name => cat).first.id,
              :data_type => 'admissions',
              :description => d[:description],
              :stat_type => d[:stat_type]
            )
            dataset.save!
            puts "Outpatient Dataset: #{handle}"

            csv.each do |row|
              zip_id = get_area_id(row["Location"])
              if row[d[:parse_token]].to_s =~ /\d.*/
                count = row[d[:parse_token]].gsub(",","").to_f
              else
                count = nil
              end
              n = 1000
              year = row["Year"]
              if Geography.where("id = #{zip_id.to_i}").present?
                if Statistic.where("name = 'population' and year = #{year} and geography_id = #{zip_id}").present?
                  pop = Geography.find(zip_id).population(year)
                  if count == nil
                    rate = nil
                  else
                    rate = (count/pop * n).round(1)
                  end
                  statistic = Statistic.new(
                    :dataset_id => Dataset.where("slug = '#{handle}'").first.id,
                    :geography_id => zip_id,
                    :year => year,
                    :name => handle, 
                    :value => rate
                  )
                  statistic.save!
                  puts "importing geography #{zip_id}"
                end
              end
            end
          end
        end

    end
  end
end