module ApplicationHelper

  def current_menu
    @current_menu
  end
  
  def current_menu_class(menu_name)
    return "active" if current_menu == menu_name
  end

  def get_datasets(geography_id, category_id)
    Dataset.joins(:statistics)
      .select("datasets.id, datasets.name, datasets.description")
      .where("statistics.geography_id = #{geography_id} AND datasets.category_id = #{category_id}")
      .group("datasets.id, datasets.name")
      .order("datasets.name")
  end

  def community_area_geojson(dataset_id, year)

    area_stats = Geography.joins(:statistics)
      .select("geographies.id, geographies.name, geographies.slug, geographies.geometry, statistics.name as condition_title, statistics.value as condition_value")
      .where("dataset_id = #{dataset_id} and year = #{year} and geo_type = 'Community Area'")

    geojson = []
    area_stats.all.each do |c|
      geojson << {
        "type" => "Feature", 
        "id" => c.id,
        "properties" => {
            "name" => c.name,
            "slug" => c.slug,
            "condition_title" => c.condition_title,
            "condition_value" => c.condition_value
        },
        "geometry" => ActiveSupport::JSON.decode(c.geometry)
      }
    end

    ActiveSupport::JSON.encode({"type" => "FeatureCollection", "features" => geojson})
  end

  def choropleth_function(grades)
    grades = Array.new(grades).reverse

    color_hash = ['#08519C', '#3182BD', '#6BAED6', '#BDD7E7']

    color_block = "";
    grades.each_with_index do |c, i|
      color_block += "d > #{c} ? '#{color_hash[i]}' : "
    end

    "return #{color_block} '#EFF3FF';"
  end

  def fetch_chart_data(dataset_id, geography_id)
    stats = Statistic.where("dataset_id = #{dataset_id} AND geography_id = #{geography_id}")
                     .order("year")

    if stats.length == 0
      return {:data => [], :error_bars => [], :start_year => '', :end_year => ''}
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

    {:data => stats_array, :error_bars => error_bars, :start_year => stats.first.year.to_s, :end_year => stats.last.year.to_s}
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

  def atlas_view_modes
    return {"Births" => 
                { "views" => ["Birth Rate",
                              "General Fertility Rate",
                              "Low Birth Weight",
                              "Prenatal Care Beginning in First Trimester",
                              "Preterm Births",
                              "Teen Birth Rate"],
                  "colors" =>  ["#BDD7E7", "#6BAED6", "#3182BD", "#08519C"]
                },
            "Deaths" => 
                { "views" => ["Assault (Homicide)",
                              "Breast cancer in females",
                              "Cancer (All Sites)",
                              "Colorectal Cancer",
                              "Diabetes-related",
                              "Firearm-related",
                              "Infant Mortality Rate",
                              "Lung Cancer",
                              "Prostate Cancer in Males",
                              "Stroke (Cerebrovascular Disease)"],
                  "colors" =>  ["#FCAE91", "#FB6A4A", "#DE2D26", "#A50F15"]
                },
            "Lead" => 
                { "views" => ["Childhood Blood Lead Level Screening",
                              "Childhood Lead Poisoning"],
                  "colors" =>  ["#CCCCCC", "#969696", "#636363", "#252525"]
                },
            "Infectious disease" => 
                { "views" => ["Gonorrhea in Females",
                              "Gonorrhea in Males",
                              "Tuberculosis"],
                  "colors" =>  ["#FDBE85", "#FD8D3C", "#E6550D", "#A63603"]
                },
            "Demographics" => 
                { "views" => ["Below Poverty Level",
                              "Crowded Housing",
                              "Dependency",
                              "No High School Diploma",
                              "Per Capita Income",
                              "Unemployment"],
                  "colors" =>  ["#CBC9E2", "#9E9AC8", "#756BB1", "#54278F"]
                }
            }
  end

end
