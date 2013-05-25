module ApplicationHelper

  def current_menu
    @current_menu
  end
  
  def current_menu_class(menu_name)
    return "active" if current_menu == menu_name
  end

  def get_datasets(geography_id, category_id)
    Dataset.joins(:statistics)
      .select("datasets.id, datasets.name, datasets.description, datasets.stat_type, datasets.slug")
      .where("statistics.geography_id = #{geography_id} AND datasets.category_id = #{category_id}")
      .group("datasets.id, datasets.name")
      .order("datasets.name")
  end

  def geography_geojson(dataset_id)

    area_stats = Geography
      .select("geographies.id, geographies.name, geographies.slug, geographies.geometry, statistics.name as condition_title, statistics.value as condition_value, statistics.year as condition_year, statistics.year_range as condition_year_range, datasets.stat_type, datasets.name as dataset_name")
      .joins("join statistics on statistics.geography_id = geographies.id")
      .joins("join datasets on datasets.id = statistics.dataset_id")
      .where("dataset_id = #{dataset_id}")
      .where("geo_type = 'Community Area' or geo_type = 'Zip'")
      .order("geographies.id, statistics.year")

    geojson = []
    values_by_year = { }
    last_geo = { "id" => nil }
    
    area_stats.all.each do |c|
      if c['id'] == last_geo['id']
        # append value to existing timeline of values for this geography
        values_by_year[ c.condition_year ] = c.condition_value
      else
        if last_geo['id'] != nil
          # there are no more points for the previous geo; output it
          geojson << {
            "type" => "Feature", 
            "id" => last_geo['id'],
            "properties" => {
              "name" => last_geo['name'],
              "slug" => last_geo['slug'],
              "stat_type" => last_geo['stat_type'],
              "condition_title" => last_geo['dataset_name'],
              "condition_value" => values_by_year,
              "condition_year_range" => last_geo['condition_year_range']
            },
            "geometry" => ActiveSupport::JSON.decode(last_geo['geometry'])
          }
        end
        # reset to accept this and next geo
        values_by_year = { c.condition_year => c.condition_value }
        last_geo = {
          "id" => c.id,
          "name" => c.name,
          "slug" => c.slug,
          "stat_type" => c.stat_type,
          "dataset_name" => c.dataset_name,
          "geometry" => c.geometry,
          "condition_year_range" => c.condition_year_range
        }
      end
    end
    # output last geo
    if last_geo['id'] != nil
      # there are no more points for the previous geo; output it
      geojson << {
        "type" => "Feature", 
        "id" => last_geo['id'],
        "properties" => {
          "name" => last_geo['name'],
          "slug" => last_geo['slug'],
          "stat_type" => last_geo['stat_type'],
          "condition_title" => last_geo['dataset_name'],
          "condition_value" => values_by_year,
          "condition_year_range" => last_geo['condition_year_range']
        },
        "geometry" => ActiveSupport::JSON.decode(last_geo['geometry'])
      }
    end

    ActiveSupport::JSON.encode({"type" => "FeatureCollection", "features" => geojson})
  end

  def intervention_locations(dataset_id, bounds=nil)
    # send boundary with [ north, east, south, west ]

    interventions = InterventionLocation
      .select('intervention_locations.name, address, latitude, longitude')
      .joins('join intervention_location_datasets on intervention_location_datasets.intervention_location_id = intervention_locations.id')
      .where("intervention_location_datasets.dataset_id = #{dataset_id}")

    if bounds
      bounds[0] = bounds[0].gsub(/[,]/, '.').to_f
      bounds[1] = bounds[1].gsub(/[,]/, '.').to_f
      bounds[2] = bounds[2].gsub(/[,]/, '.').to_f
      bounds[3] = bounds[3].gsub(/[,]/, '.').to_f

      interventions = interventions.where("latitude < #{bounds[0]} AND longitude < #{bounds[1]} AND latitude > #{bounds[2]} AND longitude > #{bounds[3]}")
    end

    locations = []
    interventions.each do |p|
      locations << [p[:name], p[:address], p[:latitude], p[:longitude]]
    end
    locations
  end

  def choropleth_function(grades)
    grades = Array.new(grades).reverse

    color_hash = ['#08519C', '#3182BD', '#6BAED6', '#BDD7E7']

    color_block = "";
    grades.each_with_index do |c, i|
      if c == 0
        color_block += "d >= #{c} ? '#{color_hash[i]}' : "
      else 
        color_block += "d > #{c} ? '#{color_hash[i]}' : "
      end
    end

    "return #{color_block} '#EFF3FF';"
  end

  def fetch_chart_data(dataset_id, geography_id)
    stats = Statistic.where("dataset_id = #{dataset_id} AND geography_id = #{geography_id}")
                     .order("year")

    if stats.length == 0
      return {:data => [], :error_bars => [], :start_year => '', :end_year => '', :year_range => ''}
    end

    stats_array = []
    stats.each do |s|
      stats_array << ((s[:value].nil? or s[:value] == '') ? 0 : s[:value])
    end

    error_bars = []
    stats.each do |s|
      unless (s[:lower_ci].nil? or s[:upper_ci].nil?)
        error_bars << [s[:lower_ci],s[:upper_ci]]
      else
        error_bars << [0,0]
      end
    end

    {:data => stats_array, :error_bars => error_bars, :start_year => stats.first.year.to_s, :end_year => stats.last.year.to_s, :year_range => stats.first.year_range}
  end

  def fetch_demographic_sex_data(sex_group, geography_id)
    stats = Statistic.joins('INNER JOIN datasets ON datasets.id = statistics.dataset_id')
                     .where("datasets.name LIKE '% #{sex_group} TOTAL%'") # brittle way to get this data
                     .where("geography_id = #{geography_id}")
                     .where("year in (2000,2010)")
                     .order("year")

    if stats.length == 0
      return {:data => [], :start_year => '', :end_year => ''}
    end

    stats_array = []
    stats.each do |s|
      stats_array << ((s[:value].nil? or s[:value] == '') ? 0 : s[:value])
    end

    {:data => stats_array, :start_year => stats.first.year.to_s, :end_year => stats.last.year.to_s}
  end

  def fetch_demographic_age_data(age_group, geography_id)
    stats = Statistic.joins('INNER JOIN datasets ON datasets.id = statistics.dataset_id')
                     .where("datasets.name LIKE '% ALL #{age_group}%'") # brittle way to get this data
                     .where("geography_id = #{geography_id}")
                     .where("year in (2010)")
                     .order("year")

    if stats.length == 0
      return {:data => [], :start_year => '', :end_year => ''}
    end

    stats_array = []
    stats.each do |s|
      stats_array << ((s[:value].nil? or s[:value] == '') ? 0 : s[:value])
    end

    {:data => stats_array, :start_year => stats.first.year.to_s, :end_year => stats.last.year.to_s}
  end

  def to_dom_id(s)
    #strip the string
    ret = s.strip.downcase

    #blow away apostrophes
    ret.gsub! /['`.]/,""

    # @ --> at, and & --> and
    ret.gsub! /\s*@\s*/, " at "
    ret.gsub! /\s*&\s*/, " and "

    #replace all non alphanumeric, underscore or periods with underscore
     ret.gsub! /\s*[^A-Za-z0-9\.\-]\s*/, '_'  

     #convert double underscores to single
     ret.gsub! /_+/,"_"

     #strip off leading/trailing underscore
     ret.gsub! /\A[_\.]+|[_\.]+\z/,""

     ret
  end

end
