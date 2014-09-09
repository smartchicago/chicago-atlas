namespace :db do
  namespace :import do
    namespace :injuries do
        desc "Import injuries among outpatient admissions from csv"
        task :injuries_outpatient => :environment do
          require 'csv'

          cat = 'Injuries Among Outpatient Admissions'
          cat_id = Category.where(:name => cat).first.id
          Dataset.where(:category_id => cat_id).each do |d|
            Statistic.delete_all(:dataset_id => d.id)
            d.delete
          end

          datasets = [
            {:name => 'Total', :parse_token => 'Total', :description => 'All injuries among outpatient admissions'},
            {:name => 'Motor Vehicle', :parse_token => 'Motor Vehicle Traffic Accidents', :description => 'Motor vehicle traffic accidents'},
            {:name => 'Other Transportation', :parse_token => 'Other Transporation Accidents', :description => 'Other transportation accidents'},
            {:name => 'Poisoning', :parse_token => 'Accidental Poisoning by Drugs, Medicinal Substances, and Biologicals', :description => 'Accidental poisoning by drugs, medicinal substances, and biologicals'},
            {:name => 'Patient Mishap', :parse_token => 'Misadventures to Patients or Abnormal Reaction of Patient', :description => 'Misadventures to patients or abnormal reactions of patients'},
            {:name => 'Falls', :parse_token => 'Accidental Falls', :description => 'Accidental falls'},
            {:name => 'Strike by Object', :parse_token => 'Accidentally Struck by Objects', :description => 'Accidental strikes by objects'},
            {:name => 'Cutting Instrument', :parse_token => 'Accidents Caused by Cutting/Piercing Instruments or Objects', :description => 'Accidents caused by cutting/piercing instruments or objects'},
            {:name => 'Overexertion', :parse_token => 'Overexertion or Strenuous Movements', :description => 'Overexertion or strenuous movements'},
            {:name => 'Other Accidents', :parse_token => 'All Other Accidents', :description => ''},
            {:name => 'Therapeutic Drug', :parse_token => 'Drugs, Medicinal and Biological Substances (In Therapeutic Use)', :description => 'Drugs, medicinal and biological substances (in therapeutic use)'},
            {:name => 'Self-Inflicted', :parse_token => 'Suicide and Self-Inflicted Injury', :description => 'Suicide and self-inflicted injuries'},
            {:name => 'Fight/Brawl/Rape', :parse_token => 'Fight, Brawl, Rape', :description => 'Fights, brawls and rapes'},
            {:name => 'Other Purposely-Inflicted', :parse_token => 'Other Homicide and Injury Purposely Inflicted by Other Persons', :description => 'Other homicides and injuries purposely inflicted by other persons'},
            {:name => 'Other External Injuries', :parse_token => 'All Other External Causes of Injury', :description => 'All other external causes of injury'}
          ]

          csv_text = File.read("db/import/injuries_outpatient_admissions.csv")
          csv = CSV.parse(csv_text, :headers => true)

          datasets.each do |d|
            handle = "#{cat} #{d[:name]}".parameterize.underscore.to_sym

            dataset = Dataset.new(
              :name => d[:name],
              :slug => handle,
              :description => d[:description],
              :provider => '',
              :url => '',
              :category_id => Category.where(:name => cat).first.id,
              :data_type => 'injuries',
              :stat_type => 'count'
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

    end
  end
end