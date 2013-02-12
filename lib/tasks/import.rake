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

      Dataset.where(:provider => "Chicago Department of Public Health").each do |d|
        Statistic.delete_all("dataset_id = #{d.id}")
        d.delete
      end

      datasets = [
        {:category => 'Births', :name => 'Births and Birth Rate', :parse_token => 'Birth Rate', :socrata_id => '4arr-givg'},
        {:category => 'Births', :name => 'General Fertility Rate', :parse_token => 'Fertility Rate', :socrata_id => 'g5zk-9ycw'},
        {:category => 'Births', :name => 'Low Birth Weight', :parse_token => 'Percent', :socrata_id => 'fbxr-9u99'},
        {:category => 'Births', :name => 'Parental Care', :parse_token => 'Percent', :socrata_id => '2q9j-hh6g'},
        {:category => 'Births', :name => 'Preterm Births', :parse_token => 'Percent', :socrata_id => 'rhy3-4x2f'},
        {:category => 'Births', :name => 'Teen Births', :parse_token => 'Teen Birth Rate', :socrata_id => '9kva-bt6k'},
      ]

      datasets.each do |d|
        handle = d[:name].gsub(/\s+/, "_").downcase.to_sym
        
        dataset = Dataset.new(
          :name => d[:name],
          :slug => handle,
          :description => '', # leaving blank for now
          :provider => 'Chicago Department of Public Health',
          :url => "https://data.cityofchicago.org/views/#{d[:socrata_id]}",
          :category_id => Category.where(:name => d[:category]).first.id
        )
        dataset.save!

        puts "downloading '#{d[:name]}'"
        sh "curl -o tmp/#{handle}.csv https://data.cityofchicago.org/api/views/#{d[:socrata_id]}/rows.csv?accessType=DOWNLOAD"
      
        csv_text = File.read("tmp/#{handle}.csv")
        csv = CSV.parse(csv_text, :headers => true)

        puts csv.first.inspect
        csv.each do |row|
          row = row.to_hash.with_indifferent_access

          # sometimes Community Area is named differently
          community_area = row['Community Area']
          if community_area.nil? || community_area == ''
            community_area = row['Community Area Number']
          end

          (1980..2013).each do |year|
            if (row.has_key?("#{d[:parse_token]} #{year}"))
              stat = Statistic.new(
                :dataset_id => dataset.id,
                :geography_id => community_area,
                :year => year,
                :value => row["d[:parse_token] #{year}"],
              )

              if (row.has_key?("d[:parse_token] #{year} Lower CI"))
                stat.lower_ci = row["d[:parse_token] #{year} Lower CI"]
              end

              if (row.has_key?("d[:parse_token] #{year} Upper CI"))
                stat.upper_ci = row["d[:parse_token] #{year} Upper CI"]
              end

              stat.save!
            end
          end
        end
        stat_count = Statistic.count(:conditions => "dataset_id = #{dataset.id}")
        puts "imported #{stat_count} statistics"
      end
      puts 'Done!'
    end
  end
end