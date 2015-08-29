namespace :db do
  namespace :import do
    namespace :providers do
      
      desc "Import hospital info from local file"
      task :hospitals => :environment do
        require 'csv'
        require 'json'

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
            :contact_phone => row["contact_phone"],
            :lat_long => row["lat_long"],
            :description => row["description"],
            :phone => row["hospital_phone"],
            :url => row["hospital_url"],
            :report_url => row["report_url"],
            :report_name => row["report_name"],
            :geometry => "none"
          )
          puts "importing #{hospital.name}"
          hospital.save!
        end

        Dir.glob("db/import/service_areas/*.geojson") do |geojson|
          id = geojson.dup
          id.slice! "db/import/service_areas/"
          id.slice! ".geojson"

          hospital = Provider.where(:primary_type => 'Hospital', :src_id => id.to_i).first
          areas = JSON.parse(open(geojson).read)['features']
          hospital.geometry = ActiveSupport::JSON.encode(areas)
          hospital.save!
        end

        puts 'Done!'
      end
    end
  end
end