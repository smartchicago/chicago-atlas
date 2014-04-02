namespace :db do
  namespace :import do    
    namespace :purple_binder do 

      desc "Fetch all Purple Binder locations"
      task :all => :environment do
        require 'open-uri'
        require 'json'
        
        # clear out existing intervention locations and relational talbes
        Dataset.where(:provider => ["Purple Binder", "Chicago Community Oral Health Forum"]).each do |d|
          InterventionLocation.delete_all("dataset_id = #{d.id}")
          d.delete
        end

        dataset_pb = Dataset.new(
          :name => 'Purple Binder programs',
          :slug => 'purple_binder_programs',
          :description => '', # leaving blank for now
          :provider => 'Purple Binder',
          :url => 'http://purplebinder.com/',
          # :category_id => Category.where(:name => d[:category]).first.id,
          :data_type => 'intervention'
        )
        dataset_pb.save!

        dataset_oral_health = Dataset.new(
          :name => 'Oral Health Clinics',
          :slug => 'chicago-metro-oral-health-clinics',
          :description => '', # leaving blank for now
          :provider => 'Chicago Community Oral Health Forum',
          :url => 'http://www.heartlandalliance.org/oralhealth/',
          # :category_id => Category.where(:name => d[:category]).first.id,
          :data_type => 'intervention'
        )
        dataset_oral_health.save!

        # page = 1
        # programs = JSON.parse(open("http://app.purplebinder.com/api/programs?page=#{page}", "Authorization" => "Token token=\"#{ENV['purple_binder_token']}\"").read)['programs']

        # command for downloading PB data
        # curl http://app.purplebinder.com/api/programs   -H 'Authorization: Token token="{purple_binder_token}"' > pb_programs.json

        programs = JSON.parse(open("db/import/pb_programs.json").read)
        # while (!programs.nil? and programs != []) do
          # puts "reading page #{page}"
          programs.each do |p|

            dataset_id = dataset_pb.id
            if p['datasets'].include? 'chicago-metro-oral-health-clinics'
              dataset_id = dataset_oral_health.id
            end

            if p['locations'].length > 0 and p['locations'].first['lat'] != ''

              intervention = InterventionLocation.new(
                :organization_name => p["organization_name"],
                :program_name => p["name"],
                :hours => (p["hours"].nil? ? "" : p["hours"]),
                :phone => (p["phone"].nil? ? "" : p["phone"]),
                :tags => ActiveSupport::JSON.encode(p["tags"]),
                :purple_binder_url => p["purple_binder_url"],
                :program_url => p["program_url"],
                :categories => ActiveSupport::JSON.encode(p["categories"]),
                :address => p['locations'].first["address"],
                :city => p['locations'].first["city"],
                :state => p['locations'].first["state"],
                :zip => p['locations'].first["zip"],
                :latitude => p['locations'].first["lat"],
                :longitude => p['locations'].first["lng"],
                :dataset_id => dataset_id
              )
              intervention.save!

            else
              puts 'no location'
              puts p.inspect
            end
          # end

          # page = page + 1
          # programs = JSON.parse(open("http://app.purplebinder.com/api/programs?page=#{page}", "Authorization" => "Token token=\"#{ENV['purple_binder_token']}\"").read)['programs']
        end

        stat_count = InterventionLocation.count(:conditions => "dataset_id = #{dataset_pb.id}")
        puts "imported #{stat_count} PB locations"

        stat_count = InterventionLocation.count(:conditions => "dataset_id = #{dataset_oral_health.id}")
        puts "imported #{stat_count} Oral Health locations"

        puts 'Done!'
      end
    end
  end
end