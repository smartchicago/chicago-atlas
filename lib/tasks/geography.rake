namespace :db do
  namespace :import do
    namespace :geography do

      desc "Download Chicago Community Areas from the TribApps Boundary Service"
      task :community_areas_download => :environment do
        require 'open-uri'
        require 'json'
        
        community_areas_all = []
        community_area_endpoints = JSON.parse(open("http://boundaries.tribapps.com/1.0/boundary-set/community-areas/").read)['boundaries']
        community_area_endpoints.each do |endpoint|
          community_areas_all << JSON.parse(open("http://boundaries.tribapps.com/#{endpoint}").read)
          sleep 1
        end

        fJson = File.open("db/import/community_areas.geojson","w")
        fJson.write('{"type": "FeatureCollection","features": ' + ActiveSupport::JSON.encode(community_areas_all) + '}')
        fJson.close

        puts 'Done!'
      end
      
      desc "Import Chicago Community Areas from local file"
      task :community_areas => :environment do
        require 'open-uri'
        require 'json'
        Geography.delete_all(:geo_type => 'Community Area')

        community_areas = JSON.parse(open("db/import/community_areas.geojson").read)['features']
        community_areas.each do |area_json|

          area = Geography.new(
            :geo_type => 'Community Area',
            :name => area_json['name'],
            :slug => area_json['name'].parameterize.underscore.to_sym,
            :geometry => ActiveSupport::JSON.encode(area_json['simple_shape']),
            :centroid => ActiveSupport::JSON.encode(area_json['centroid']['coordinates']),
            :adjacent_zips => ActiveSupport::JSON.encode(area_json['adjacent_zips']),
            :adjacent_community_areas => ActiveSupport::JSON.encode(area_json['adjacent_community_areas']),
          )
          area.id = area_json['external_id']
          puts "importing #{area.name}"
          area.save!
        end

        puts 'Done!'
      end

      desc "Import zip code geographies from local file"
      task :zip_codes => :environment do
        require 'json'
        Geography.delete_all(:geo_type => 'Zip')

        zips = JSON.parse(open("db/import/zipcodes.geojson").read)['features']
        zips.each do |zip|

          unless zip['properties']['merged']

            zip_name = zip['properties']['ZIP']
            if zip['properties']['name']
              zip_name = zip['properties']['name']
            end

            area = Geography.new(
              :geo_type => 'Zip',
              :name => zip_name,
              :slug => zip['properties']['ZIP'],
              :geometry => ActiveSupport::JSON.encode(zip['geometry']),
              :adjacent_zips => ActiveSupport::JSON.encode(zip['properties']['adjacent_zips']),
              :adjacent_community_areas => ActiveSupport::JSON.encode(zip['properties']['adjacent_community_areas']),
            )
            area.id = zip['properties']['ZIP']
            puts "importing #{area.name}"
            area.save!
          end
        end

        # add centroid attribute from separate file
        centroids = JSON.parse(open("db/import/zipcode_centroids.geojson").read)['features']
        centroids.each do |centroid|

          zip_boundary = Geography.where(:id => centroid['properties']['ZIP']).first

          if zip_boundary
            area = zip_boundary
            area.centroid= ActiveSupport::JSON.encode(centroid['geometry']['coordinates'])
            puts "adding centroid for #{area.name}"
            area.save!
          end
        end

        puts 'Done!'
      end
    end
  end
end