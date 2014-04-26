namespace :db do
  namespace :import do    
    namespace :insurance do 

      desc "Import insurance coverage percent by community area"
      task :all => :environment do
        require 'csv' 

        Dataset.where(:category_id => Category.where("name = 'Health Insurance'").first).each do |d|
          Statistic.delete_all("dataset_id = #{d.id}")
          d.delete
        end

        datasets = [
          {:category => 'Health Insurance', :name => 'Health Insurance', :file => 'health_insurance_by_community_area_2008-2012.csv'},
        ]

        select_columns = [
          "All Uninsured",
          "By Age: 0 to 17 Uninsured",
          "By Age: 18 to 64 Uninsured",
          "By Age: 65 and over Uninsured",
          "By Race: White Uninsured",
          "By Race: Latino Uninsured",
          "By Race: Black Uninsured",
          "By Race: Asian Uninsured",
          "By Nativity: Native-Born Uninsured",
          "By Nativity: Foreign-Born Uninsured",
          "By Nativity: Foreign-Born Citizen Uninsured",
          "By Nativity: Foreign-Born Noncitizen Uninsured",
          "By School Enrollment: 19 to 25 Uninsured",
          "By School Enrollment: Enrolled 19 to 25 Uninsured",
          "By School Enrollment: Not enrolled 19 to 25 Uninsured",
          "By Income: Under 138% of Poverty Line Uninsured",
          "By Income: 138 to 199% of Poverty Line Uninsured",
          "By Income: 200 to 399% of Poverty Line Uninsured",
          "By Income: 400% and over Poverty Line Uninsured"
        ]


        datasets.each do |d|
          csv_text = File.read("db/import/#{d[:file]}")
          csv = CSV.parse(csv_text, :headers => true)

          select_columns.each do |col|
            name = "#{d[:category]} #{col}"
            handle = "#{name}".parameterize.underscore.to_sym

            dataset = Dataset.new(
              :name => name,
              :slug => handle,
              :description => "Health Insurance: #{col}",
              :provider => 'American Community Survey, 2008-2012 as processed by Rob Paral and Associates',
              :url => "https://www.census.gov/acs/www/",
              :category_id => Category.where(:name => d[:category]).first.id,
              :data_type => 'demographic',
              :stat_type => 'range, percent'
            )
            dataset.save!

            csv.each do |row|
              row = row.to_hash.with_indifferent_access

              area = row["Community Area Id"]
              area = get_area_id(area)

              stat = Statistic.new(
                :dataset_id => dataset.id,
                :geography_id => area,
                :year => 2008,
                :year_range => '2008 - 2012',
                :name => name, 
                :value => row[col].to_f*100
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