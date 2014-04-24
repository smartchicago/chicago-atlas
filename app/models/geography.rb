class Geography < ActiveRecord::Base
  has_many :statistics

  attr_accessible :geo_type, :name, :external_id, :slug, :centroid, :geometry, :adjacent_zips, :adjacent_community_areas

  def centroid_as_lat_lng
    my_centroid = JSON.parse(centroid)
    [my_centroid[1],my_centroid[0]]
  end

  def population(year)
    pop = Statistic.joins('INNER JOIN datasets ON datasets.id = statistics.dataset_id')
                     .where("datasets.slug = 'population_all_total'") # brittle way to get this data
                     .where("geography_id = #{id}")
                     .where("year = #{year}").first

    unless pop.nil?
      pop.value.to_i
    else
      0
    end
  end

  def population_change(year_1, year_2)
    change = ((1-(population(year_1).to_f / population(year_2)))*100).round

    if change > 0 
      "<span class='label label-success'>+#{change}%</span>"
    else
      "<span class='label label-important'>#{change}%</span>"
    end
    
  end

  def population_by_sex(gender)
    stats = Statistic.joins('INNER JOIN datasets ON datasets.id = statistics.dataset_id')
                     .where("datasets.name = 'Population #{gender} TOTAL'")
                     .where("geography_id = ? AND year = 2010", id)

    if stats.length > 0
      stats.first.value
    else
      0
    end
  end

  def demographic_by_name(name)
    handle = name.parameterize.underscore.to_sym
    demo = Statistic.joins('JOIN datasets ON statistics.dataset_id = datasets.id')
                    .select('datasets.name as name, statistics.value, datasets.description, datasets.stat_type') 
                    .where('statistics.name = ? and geography_id = ?', handle, id)

    if demo.length > 0
      demo.first
    else
      nil
    end
  end

  def has_category(category_name)
    cat = Category.joins('INNER JOIN datasets ON datasets.category_id = categories.id')
                  .joins('INNER JOIN statistics ON datasets.id = statistics.dataset_id')
                  .where("statistics.geography_id = ?", id)
                  .where("categories.name = ?", category_name)

    if cat.count > 0
      true
    else
      false
    end
  end
end
