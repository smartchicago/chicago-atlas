namespace :db do
  namespace :import do    
    namespace :census do 

      desc "Import population by year by community area and zip code"
      task :population => :environment do
        require 'csv' 

        Dataset.where(:category_id => Category.where("name = 'Demographics'").first).each do |d|
          Statistic.delete_all("dataset_id = #{d.id}")
          d.delete
        end

        datasets = [
          {:category => 'Demographics', :name => 'Population', :file => 'population_estimates_1999_2011'},
        ]

        age_groups = ['TOTAL'].concat( GlobalConstants::AGE_GROUPS )
        sex_groups = ['ALL'].concat( GlobalConstants::SEX_GROUPS )

        datasets.each do |d|
          csv_text = File.read("db/import/#{d[:file]}.csv")
          csv = CSV.parse(csv_text, :headers => true)

          age_groups.each do |age_group|
            sex_groups.each do |sex_group|
              name = "#{d[:name]} #{sex_group} #{age_group}"
              handle = name.parameterize.underscore.to_sym

              dataset = Dataset.new(
                :name => name,
                :slug => handle,
                :description => "Population of #{sex_group} aged #{age_group} based on US Census",
                :provider => 'US Census',
                :url => d[:url],
                :category_id => Category.where(:name => d[:category]).first.id,
                :data_type => 'demographic',
                :stat_type => 'count'
              )
              dataset.save!

              csv.each do |row|
                row = row.to_hash.with_indifferent_access

                area = row["AREA"]
                area = get_area_id(area)

                if row['AGEGP'] == age_group and row['SEXGP'] == sex_group
                  (1999..Time.now.year).each do |year|
                    if (row.has_key?("POP#{year}"))
                      stat = Statistic.new(
                        :dataset_id => dataset.id,
                        :geography_id => area,
                        :year => year,
                        :name => 'population', 
                        :value => row["POP#{year}"]
                      )

                      stat.save!
                    end
                  end
                end
              end

              stat_count = Statistic.count(:conditions => "dataset_id = #{dataset.id}")
              puts "imported #{stat_count} statistics: #{sex_group}, #{age_group}"
            end
          end
        end
        Rake::Task["db:import:set_visibility:all"].invoke
      end
    end
  end
end