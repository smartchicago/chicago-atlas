namespace :db do
  namespace :import do    
    namespace :dentists do 

      desc "Import number of dentists by community area"
      task :all => :environment do
        require 'csv' 

        Dataset.where(:category_id => Category.where("name = 'Providers'").first).each do |d|
          Statistic.delete_all("dataset_id = #{d.id}")
          d.delete
        end

        datasets = [
          {:category => 'Providers', :name => 'Dentists', :file => 'practicing_dentists_by_community_area.csv'},
        ]

        select_columns = [
          "Practicing Dentists"
        ]

        datasets.each do |d|
          csv_text = File.read("db/import/#{d[:file]}")
          csv = CSV.parse(csv_text, :headers => true)

          select_columns.each do |col|
            name = "#{col}"
            handle = "#{d[:category]} #{d[:name]}".parameterize.underscore.to_sym

            dataset = Dataset.new(
              :name => name,
              :slug => handle,
              :description => "Practicing dentists by Chicago community area in 2010.",
              :provider => 'Chicago Community Oral Health Forum',
              :url => "http://www.heartlandalliance.org/oralhealth/",
              :category_id => Category.where(:name => d[:category]).first.id,
              :data_type => 'demographic',
              :stat_type => 'count'
            )
            dataset.save!

            csv.each do |row|
              row = row.to_hash.with_indifferent_access

              area = row["Community Area Id"]
              area = get_area_id(area)

              # adjust count by community area population
              # comm_population = Geography.find(row["Community Area Id"]).population(2010)

              # raw_count = row[col].to_f or 0
              # rate = '%.2f' % (raw_count / (comm_population / 1000.0))  # rate per 1000 residents


              stat = Statistic.new(
                :dataset_id => dataset.id,
                :geography_id => area,
                :year => 2010,
                :year_range => '2010',
                :name => name, 
                :value => row[col]
              )
              stat.save!
              
            end

            stat_count = Statistic.count(:conditions => "dataset_id = #{dataset.id}")
            puts "imported #{stat_count} statistics: #{col}"
          end
        end
      end
    end
  end
end