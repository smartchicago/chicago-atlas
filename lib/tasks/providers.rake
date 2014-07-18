namespace :db do
  namespace :import do
    namespace :providers do
      
      desc "Import hospital info from local file"
      task :hospitals => :environment do
        require 'csv'

        Provider.where("primary_type = 'Hospital'").each do |d|
          d.delete
        end

        csv_text = File.read("db/import/hospital_info_prepped.csv")
        csv = CSV.parse(csv_text, :headers => true)

        csv.each do |row|
          hospital = Provider.new(
            :src_id => row["hospital_id"],
            :name => row["hospital_name"],
            :slug => row["hospital_name"].parameterize.underscore.to_sym,
            :primary_type => row["provider_type"],
            :sub_type => row["provider_sub_type"],
            :addr_street => row["address_street"],
            :addr_city => row["address_city"],
            :addr_zip => row["address_zip"],
            :ownership_type => row["ownership_type"],
            :contact_email => row["contact_email"],
            :contact_phone => row["contact_phone"]
          )
          puts "importing #{hospital.name}"
          hospital.save!
        end

        puts 'Done!'
      end
    end
  end
end