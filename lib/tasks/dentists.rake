namespace :db do
  namespace :import do    
    namespace :dentists do 

      desc "Import number of dentists by community area"
      task :all => :environment do
        require 'csv' 

        Dataset.where(:category_id => 18).each do |d|
          Statistic.delete_all("dataset_id = #{d.id}")
          d.delete
        end

        datasets = [
          {:category => 'Dentists', :name => 'Total Dentists', :description => 'Total practicing dentists per 1,000 residents by Chicago zip code', :stat_type => 'rate', :rate => true, :csv_column => 'dentists_total' },
          {:category => 'Dentists', :name => 'General Dentists (No Specialty)', :description => 'Total practicing general dentists with no specialty per 1,000 residents by Chicago zip code', :stat_type => 'rate', :rate => true, :csv_column => 'dentists_general' },
          {:category => 'Dentists', :name => 'Pediatric Dentists (No Specialty)', :description => 'Total practicing pediatric dentists with no specialty per 1,000 residents by Chicago zip code', :stat_type => 'rate', :rate => true, :csv_column => 'dentists_pediatric' },
          {:category => 'Dentists', :name => 'Specialist Dentists', :description => 'Total practicing specialist dentists per 1,000 residents by Chicago zip code', :stat_type => 'rate', :rate => true, :csv_column => 'dentists_specialty' },
          {:category => 'Dentists', :name => 'Dentists (With Specialty)', :description => 'Total practicing general dentists with a specialty per 1,000 residents by Chicago zip code', :stat_type => 'rate', :rate => true, :csv_column => 'dentists_general_specialty' },
          {:category => 'Dentists', :name => 'Pediatric Dentists (With Specialty)', :description => 'Total practicing pediatric dentists with a specialty per 1,000 residents by Chicago zip code', :stat_type => 'rate', :rate => true, :csv_column => 'dentists_pediatric_specialty' }
        ]

        new_datasets = []
        datasets.each do |d|
          dataset = Dataset.new(
            :name => d[:name],
            :slug => d[:csv_column],
            :description => d[:description],
            :provider => 'U.S. Centers for Medicare and Medicaid Services, National Provider Identification files; and U.S. Census 2010 data for zip code tabulation areas, processed by Rob Paral and Associates.',
            :url => "https://www.cms.gov",
            :category_id => Category.where(:name => d[:category]).first.id,
            :data_type => 'demographic',
            :stat_type => d[:stat_type]
          )
          dataset.save!
          new_datasets.append(dataset)
        end

        puts new_datasets.length

        csv_text = File.read("db/import/dentists_by_zipcode.csv")
        csv = CSV.parse(csv_text, :headers => true)

        csv.each do |row|
          zip = row['zipcode']

          new_datasets.each do |d|
            
            stat = Statistic.new(
              :dataset_id => d.id,
              :geography_id => zip,
              :year => 2015,
              :year_range => '2015',
              :name => d.name,
              :value => row[d.slug]
            )
            stat.save!

          end

        end

      end
    end
  end
end