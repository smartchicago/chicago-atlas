namespace :db do
  namespace :import do    
    namespace :dentists do 

      desc "Import number of dentists by community area"
      task :all => :environment do
        require 'csv' 

        Dataset.where("name LIKE 'Dentists%'").each do |d|
          Statistic.delete_all("dataset_id = #{d.id}")
          d.delete
        end

        datasets = [
          {:category => 'Healthcare Providers', :name => 'Dentists', :description => 'Practicing dentists by Chicago community area in 2010.', :rate => false, :stat_type => 'count', :file => 'practicing_dentists_by_community_area.csv'},
          {:category => 'Healthcare Providers', :name => 'Dentists per 1,000 residents', :description => 'Practicing dentists per 1,000 residents by Chicago community area in 2010.', :stat_type => 'rate', :rate => true, :file => 'practicing_dentists_by_community_area.csv'},
        ]

        select_columns = [
          "Practicing Dentists"
        ]

        datasets.each do |d|
          csv_text = File.read("db/import/#{d[:file]}")
          csv = CSV.parse(csv_text, :headers => true)

          select_columns.each do |col|
            name = d[:name]
            handle = "#{d[:category]} #{d[:name]}".parameterize.underscore.to_sym

            dataset = Dataset.new(
              :name => name,
              :slug => handle,
              :description => d[:description],
              :provider => 'Chicago Community Oral Health Forum',
              :url => "http://www.heartlandalliance.org/oralhealth/",
              :category_id => Category.where(:name => d[:category]).first.id,
              :data_type => 'demographic',
              :stat_type => d[:stat_type]
            )
            dataset.save!

            csv.each do |row|
              row = row.to_hash.with_indifferent_access

              area = row["Community Area Id"]
              area = get_area_id(area)

              store_value = row[col]
              if (d[:rate])
                # adjust count by community area population
                comm_population = Geography.find(row["Community Area Id"]).population(2010)

                raw_count = row[col].to_f or 0
                store_value = '%.2f' % (raw_count / (comm_population / 1000.0))  # rate per 1000 residents
              end

              stat = Statistic.new(
                :dataset_id => dataset.id,
                :geography_id => area,
                :year => 2010,
                :year_range => '2010',
                :name => name, 
                :value => store_value
              )
              stat.save!
              
            end

            stat_count = Statistic.count(:conditions => "dataset_id = #{dataset.id}")
            puts "imported #{stat_count} statistics: #{d[:name]}"
          end
        end
      end
    end
  end
end