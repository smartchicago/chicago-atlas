class Geography < ActiveRecord::Base
  has_many :statistics

  attr_accessible :geo_type, :name, :external_id, :slug, :centroid, :geometry

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
end
