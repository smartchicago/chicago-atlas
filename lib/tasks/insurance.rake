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
          {:category => 'Health Insurance', :name => 'Health Insurance', :file => 'health_insurance_by_age_by_community_area_2008-2012'},
        ]

        select_columns = ["Total All ages Uninsured Percent",
        "Total Under 17 Uninsured Percent",
        "Total 18 to 64 Uninsured Percent",
        "Total 65 and over Uninsured Percent",
        "White NL All ages Uninsured Percent",
        "Latino All ages Uninsured Percent",
        "Black All ages Uninsured Percent",
        "Asian All ages Uninsured Percent",
        "Total Native-Born Uninsured Percent",
        "Total Foreign-Born Uninsured Percent",
        "Total Foreign-Born Citizen Uninsured Percent",
        "Total Foreign-Born Noncitizen Uninsured Percent",
        "Total 19 to 25 Uninsured Percent",
        "Enrolled in school 19 to 25 Uninsured Percent",
        "Not enrolled 19 to 25 Uninsured Percent",
        "Total Under 138% All ages Uninsured Percent",
        "Total 138 to 199% All ages Uninsured Percent",
        "Total 200 to 399% All ages Uninsured Percent",
        "Total 400% and over All ages Uninsured Percent"]


        datasets.each do |d|
          csv_text = File.read("db/import/#{d[:file]}.csv")
          csv = CSV.parse(csv_text, :headers => true)

          select_columns.each do |col|
            name = "#{col}".gsub("Total ","").gsub(" Percent","").gsub("Under ", "0 to ")
            handle = name.parameterize.underscore.to_sym

            dataset = Dataset.new(
              :name => name,
              :slug => handle,
              :description => "Health Insurance: #{col}",
              :provider => 'US Census',
              :url => d[:url],
              :category_id => Category.where(:name => d[:category]).first.id,
              :data_type => 'demographic',
              :stat_type => 'range, percent'
            )
            dataset.save!

            csv.each do |row|
              row = row.to_hash.with_indifferent_access

              area = row["CHGOCA"]
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
        Rake::Task["db:import:set_visibility:all"].invoke
        
      end
    end
  end
end