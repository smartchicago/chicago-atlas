module ApplicationHelper

  def current_menu
    @current_menu
  end

  def title(page_title)
    content_for :title, page_title.to_s
  end
  
  def current_menu_class(menu_name)
    return "active" if current_menu == menu_name
  end

  def get_datasets(geography_id, category_id)
    Dataset.joins(:statistics)
      .select("datasets.id, datasets.name, datasets.description, datasets.provider, datasets.url, datasets.stat_type, datasets.slug")
      .where("statistics.geography_id = #{geography_id} AND datasets.category_id = #{category_id}")
      .group("datasets.id, datasets.name")
      .order("datasets.name")
  end

  def get_dataset(id)
    Dataset.where(:category_id => id, :is_visible => true)
           .order("name")
  end

  def get_categories_by_type(type)
    Category.select('categories.id, categories.name, categories.description')
              .where("datasets.data_type = ?", type)
              .joins('INNER JOIN datasets ON datasets.category_id = categories.id')
              .group('categories.id, categories.name, categories.description')
              .having('count(datasets.id) > 0')
              .order("categories.name")
  end

  def get_categories_like(dataset_name, category_name)
    query = Category.select('categories.id, categories.name, categories.description')
    if dataset_name
      query = query.where("datasets.name LIKE '%#{dataset_name}%' ")
    elsif category_name
      query = query.where("categories.name LIKE '%#{category_name}%' ")
    end
    
    query = query.joins('INNER JOIN datasets ON datasets.category_id = categories.id')
              .group('categories.id, categories.name, categories.description')
              .having('count(datasets.id) > 0')
              .order("categories.name")

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

  def geography_resources_geojson()

    area_stats = Geography
      .select("geographies.id, geographies.name, geographies.slug, geographies.geometry, count(intervention_locations.community_area_id) as resource_cnt")
      .joins("LEFT JOIN intervention_locations on intervention_locations.community_area_id = geographies.id")
      .group("geographies.id")
      .where("geo_type = 'Community Area' ")

    geojson = []    
    area_stats.all.each do |c|
      geojson << {
        "type" => "Feature", 
        "id" => c.id,
        "properties" => {
          "name" => c.name,
          "slug" => "#{c.slug}/resources",
          "stat_type" => '',
          "condition_title" => 'Resources',
          "condition_value" => { Time.now.year => c.resource_cnt },
          "condition_year_range" => ''
        },
        "geometry" => ActiveSupport::JSON.decode(c.geometry)
      }
    end

    ActiveSupport::JSON.encode({"type" => "FeatureCollection", "features" => geojson})
  end

  def geography_empty_geojson()

    area_stats = Geography
      .select("geographies.id, geographies.name, geographies.slug, geographies.geometry")
      .where("geo_type = 'Community Area'")

    geojson = []    
    area_stats.all.each do |c|
      geojson << {
        "type" => "Feature", 
        "id" => c.id,
        "properties" => {
          "name" => c.name,
          "slug" => c.slug,
          "stat_type" => '',
          "condition_title" => '',
          "condition_value" => '',
          "condition_year_range" => ''
        },
        "geometry" => ActiveSupport::JSON.decode(c.geometry)
      }
    end

    ActiveSupport::JSON.encode({"type" => "FeatureCollection", "features" => geojson})
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

  def fetch_demographic_sex_data(year, geography_id)
    stats = Statistic.joins('INNER JOIN datasets ON datasets.id = statistics.dataset_id')
                     .where("datasets.name LIKE '% TOTAL%'") # brittle way to get this data
                     .where("datasets.name NOT LIKE '% ALL%'")
                     .where("geography_id = ?", geography_id)
                     .where("year = ?", year)
                     .order("datasets.name")

    if stats.length == 0
      return []
    end

    stats_array = []
    stats.each do |s|
      stats_array << ((s[:value].nil? or s[:value] == '') ? 0 : s[:value])
    end

    stats_array
  end

  def fetch_demographic_age_data(year, geography_id)
    stats = Statistic.joins('INNER JOIN datasets ON datasets.id = statistics.dataset_id')
                     .where("datasets.name LIKE '% ALL %'") # brittle way to get this data
                     .where("datasets.name NOT LIKE '% TOTAL%'")
                     .where("geography_id = ?", geography_id)
                     .where("year = ?", year)
                     .order("datasets.name")

    if stats.length == 0
      return []
    end

    stats_array = []
    stats.each do |s|
      stats_array << ((s[:value].nil? or s[:value] == '') ? 0 : s[:value])
    end

    stats_array
  end

  def fetch_custom_chart_data(geography_id, category_id=nil, like_query=nil, list_in=[])
    stats = Statistic.joins('INNER JOIN datasets ON datasets.id = statistics.dataset_id')                 

    if category_id
      stats = stats.where("datasets.category_id = ?", category_id)
    end
    if like_query
      stats = stats.where("datasets.name LIKE '#{like_query}%'")
    end
    if list_in.count > 0
      stats = stats.where("datasets.name IN (?)", list_in)
    end
    stats = stats.where("geography_id = ?", geography_id)
                 .order("datasets.id")

    if stats.length == 0
      return []
    end

    stats_array = []
    stats.each do |s|
      stats_array << ((s[:value].nil? or s[:value] == '') ? 0 : s[:value])
    end

    stats_array
  end

  def fetch_dataset_chart_headers(cat_id=nil)
    datasets = Dataset.where("category_id = '#{cat_id}'")                 

    if datasets.length == 0
      return []
    end

    datasets = datasets.order("id")
    dataset_name_array = []
    datasets.each do |d|
      dataset_name_array << (d[:name])
    end

    dataset_name_array
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

  def format_statistic(value, stat_type)
    if stat_type.include? 'percent'
      "#{value}%"
    elsif stat_type.include? 'money'
      number_to_currency value
    else
      value
    end
  end

  def render_source_links(provider_name, provider_url, source_url, is_oneline=true)
    source_string = "<small class='muted'>
      <br>
      Source: 
      <a href='#{provider_url}'>
        #{provider_name}
      </a>"
    if is_oneline
      source_string << "|"
      
    else
      source_string << "<br>"
    end
    source_string << "<a href='#{source_url}' class='nowrap'>
        <i class='icon icon-download-alt'></i>
        Data
      </a>
    </small>"

    return source_string
  end

  def fetch_provider_data(provider_id, category)
    stats = ProviderStats.where("provider_id = #{provider_id} AND stat_type = '#{category}'")

    if stats.length == 0
      return {:data => [], :start_date => '', :end_date => ''}
    end

    stat_array = []
    value_array = []
    stats.each do |s|
      stat_array << ((s[:stat].nil? or s[:stat] == '') ? 0 : s[:stat])
      value_array << ((s[:value].nil? or s[:value] == '') ? 0 : s[:value])
    end

    start_date = stats[0][:date_start]
    end_date = stats[0][:date_end]

    {:stats => stat_array, :values => value_array, :start_date => start_date, :end_date => end_date }
  end

  def fetch_sorted_provider_data(provider_id, category)
    stats = ProviderStats.where("provider_id = #{provider_id} AND stat_type = '#{category}'").order("value desc")

    if stats.length == 0
      return {:data => [], :start_date => '', :end_date => ''}
    end

    stat_array = []
    value_array = []
    stats.each do |s|
      stat_array << ((s[:stat].nil? or s[:stat] == '') ? 0 : s[:stat])
      value_array << ((s[:value].nil? or s[:value] == '') ? 0 : s[:value])
    end

    start_date = stats[0][:date_start]
    end_date = stats[0][:date_end]

    {:stats => stat_array, :values => value_array, :start_date => start_date, :end_date => end_date }
  end

end
