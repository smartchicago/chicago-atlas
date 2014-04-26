namespace :db do
  namespace :import do    
    namespace :physicians do 

      desc "Import number of doctors by community area"
      task :all => :environment do
        require 'csv' 

        Dataset.where("provider = 'Health Resources and Services Administration'").each do |d|
          Statistic.delete_all("dataset_id = #{d.id}")
          d.delete
        end

        datasets = [
          {:category => 'Healthcare Providers', :rate => false, :stat_type => 'count', :file => 'practicing_doctors_by_ca.csv'},
          {:category => 'Healthcare Providers', :rate => true, :stat_type => 'rate', :file => 'practicing_doctors_by_ca.csv'},
        ]

        select_columns = [
          "Primary Care Physicians",
          "Specialist Physicians",
          "OB-GYN Physicians",
          "Primary Care Residents and Fellows",
          "Specialist Residents and Fellows",
          "OB-GYN Residents and Fellows"
        ]

        datasets.each do |d|
          csv_text = File.read("db/import/#{d[:file]}")
          csv = CSV.parse(csv_text, :headers => true)

          select_columns.each do |col|
            name = col
            description = "#{col} by Chicago community area in 2010."
            
            if (d[:rate])
              name = "#{col} per 1,000 residents"
            end

            description = "#{name} by Chicago community area in 2010."
            handle = "#{d[:category]} #{name}".parameterize.underscore.to_sym

            dataset = Dataset.new(
              :name => name,
              :slug => handle,
              :description => description,
              :provider => 'Health Resources and Services Administration',
              :url => "http://datawarehouse.hrsa.gov/data/datadownload/pcsa2010Download.aspx",
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
            puts "imported #{stat_count} statistics: #{name}"
          end
        end
      end
    end
  end
end