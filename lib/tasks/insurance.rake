namespace :db do
  namespace :import do    
    namespace :insurance do 

      desc "Import insurance coverage percent by community area"
      task :all => :environment do
        require 'csv' 

        categories = [
          {:category => 'All Uninsured', :columns => ["All Uninsured"], description: "Percent of the population that lacks comprehensive health insurance. From the 2008-2012 American Community Survey." },
          {:category => 'Uninsured By Age', :columns => ["0 to 17 Uninsured", "18 to 64 Uninsured", "65 and over Uninsured"], description: "Percent of the children population that lacks comprehensive health insurance. From the 2008-2012 American Community Survey." },
          {:category => 'Uninsured By Race', :columns => ["White Uninsured","Latino Uninsured","Black Uninsured","Asian Uninsured"], description: "Percent of the population that lacks comprehensive health insurance. From the 2008-2012 American Community Survey." },
          {:category => 'Uninsured By Nativity', :columns => ["Native-Born Uninsured","Foreign-Born Uninsured","Foreign-Born Citizen Uninsured","Foreign-Born Noncitizen Uninsured"], description: "Percent of the population that lacks comprehensive health insurance. From the 2008-2012 American Community Survey." },
          {:category => 'Uninsured By School Enrollment', :columns => ["19 to 25 Uninsured","Enrolled 19 to 25 Uninsured","Not enrolled 19 to 25 Uninsured"], description: "Percent of the population that lacks comprehensive health insurance. From the 2008-2012 American Community Survey." },
          {:category => 'Uninsured By Income', :columns => ["Under 138% of Poverty Line Uninsured","138 to 199% of Poverty Line Uninsured","200 to 399% of Poverty Line Uninsured","400% and over Poverty Line Uninsured"], description: "Percent of the population that lacks comprehensive health insurance. Persons with incomes under 138% of the poverty level are generally eligible for Medicaid insurance and persons with incomes under 400% of the poverty level are generally eligible for subsidized insurance under the Affordable Care Act. From the 2008-2012 American Community Survey." },
        ]

        # create / update categories
        categories.each do |d|
          cat = Category.where(:name => d[:category]).first_or_create()
          cat.description = d[:description]
          cat.save

          # delete child datasets
          Dataset.where(:category_id => Category.find_by_name(cat.name)).each do |d|
            Statistic.delete_all("dataset_id = #{d.id}")
            d.delete
          end
        
          csv_text = File.read("db/import/health_insurance_by_community_area_2008-2012.csv")
          csv = CSV.parse(csv_text, :headers => true)

          d[:columns].each do |col|
            name = "#{col}"
            handle = "#{d[:category]} #{col}".parameterize.underscore.to_sym

            dataset = Dataset.new(
              :name => name,
              :slug => handle,
              :description => d[:description],
              :provider => 'American Community Survey, 2008-2012 as processed by Rob Paral and Associates',
              :url => "https://www.census.gov/acs/www/",
              :category_id => cat.id,
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