namespace :db do
  namespace :import do
    
    desc "Fetch Chicago Community Areas from the tribapps Boundary Service"
    task :community_areas => :environment do
      require 'open-uri'
      require 'json'
      Geography.delete_all

      community_area_endpoints = JSON.parse(open("http://api.boundaries.tribapps.com/1.0/boundary-set/community-areas/").read)['boundaries']
      community_area_endpoints.each do |endpoint|
        area_json = JSON.parse(open("http://api.boundaries.tribapps.com/#{endpoint}").read)
        # puts area_json.inspect

        area = Geography.new(
          :geo_type => "Community Area",
          :name => area_json['name'],
          :slug => area_json['slug'],
          :geometry => area_json['simple_shape']['coordinates']
          )
        area.id = area_json['external_id']
        puts "importing #{area.name}"
        area.save!
      end

      puts 'Done!'
    end

    desc "Fetch CDPH datasets from the Chicago Data Portal and import to database"
    task :chicago_dph => :environment do
      require 'csv' 
      Statistic.delete_all

      datasets = [
        {:name => 'Births and Birth Rate', :parse_token => 'Birth Rate', :socrata_id => '4arr-givg'}
      ]

      datasets.each do |d|
        handle = d[:name].gsub(/\s+/, "_").downcase.to_sym
        puts "downloading '#{d[:name]}'"
        sh "curl -o tmp/#{handle}.csv https://data.cityofchicago.org/api/views/#{d[:socrata_id]}/rows.csv?accessType=DOWNLOAD"
      
        csv_text = File.read("tmp/#{handle}.csv")
        csv = CSV.parse(csv_text, :headers => true)
        csv.each do |row|
          row = row.to_hash.with_indifferent_access

          (1980..2013).each do |year|
            if (row.has_key?("Birth Rate #{year}"))
              stat = Statistic.new(
                :geography_id => row['Community Area'],
                :stat_type => d[:name],
                :slug => handle,
                :year => year,
                :value => row["Birth Rate #{year}"],
                )

              if (row.has_key?("Birth Rate #{year} Lower CI"))
                stat.lower_ci = row["Birth Rate #{year} Lower CI"]
              end

              if (row.has_key?("Birth Rate #{year} Upper CI"))
                stat.upper_ci = row["Birth Rate #{year} Upper CI"]
              end

              stat.save!
            end
          end
          puts "importing Community Area #{row['Community Area']}"
        end
        puts 'Done!'
      end

    end
  end
end