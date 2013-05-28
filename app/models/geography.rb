class Geography < ActiveRecord::Base
  has_many :statistics

  attr_accessible :geo_type, :name, :external_id, :slug, :centroid, :geometry

  def centroid_as_lat_lng
    my_centroid = JSON.parse(centroid)
    [my_centroid[1],my_centroid[0]]
  end

  def pop_total(year)
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

  def pop_change
    1-(pop_total(2000).to_f / pop_total(2010))
  end
end
