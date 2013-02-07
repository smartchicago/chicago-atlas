namespace :db do
  namespace :import do
    
    desc "Fetch Chicago Community Areas from the tribapps Boundary Service"
    task :community_areas do
      db = MongoMapper.database
      require 'open-uri'
      community_area_endpoints = JSON.parse(open("http://api.boundaries.tribapps.com/1.0/boundary-set/community-areas/").read)['boundaries']
      community_area_endpoints.each do |endpoint|
        area_json = JSON.parse(open("http://api.boundaries.tribapps.com/#{endpoint}").read)
        puts area_json.inspect

        area = Geography.new(
          :type => "Community Area",
          :name => area_json['name'],
          :external_id => area_json['external_id'],
          :slug => area_json['external_id'],
          :geometry => area_json['simple_shape']['coordinates']
          )

        puts area.inspect
        area.save!

        break
      end
    end


    desc "Fetch CDPH datasets from the Chicago Data Portal and import in to mongodb"
    task :chicago_cdph do
      datasets = [
        {:name => 'Births and Birth Rate', :socrata_id => '4arr-givg'}
      ]

      datasets.each do |d|
        handle = d[:name].gsub(/\s+/, "_").downcase.to_sym
        puts "downloading '#{d[:name]}'"
        sh "curl -o tmp/#{handle}.csv https://data.cityofchicago.org/api/views/#{d[:socrata_id]}/rows.csv?accessType=DOWNLOAD"
        puts "populating #{handle} table"
        sh "mongoimport -d chicago-atlas-#{Rails.env} -c cdph_import --type csv --file tmp/#{handle}.csv --headerline"
      end

    end
  end

  namespace :test do
    task :prepare do
      # Stub out for MongoDB
    end
  end
end