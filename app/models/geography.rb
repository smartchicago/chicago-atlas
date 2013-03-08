class Geography < ActiveRecord::Base
  has_many :statistics

  attr_accessible :geo_type, :name, :external_id, :slug, :centroid, :geometry

  def centroid_as_lat_lng
    my_centroid = JSON.parse(centroid)
    [my_centroid[1],my_centroid[0]]
  end
end
