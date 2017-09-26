class GeoGroup < ActiveRecord::Base
  has_many :resources
  validates :name, presence: true

  def female_population
    resource = Indicator.find_by_slug("female-population").resources.where(geo_group_id: id).order(year_from: :desc).first
    resource ? resource.number : 0
  end

  def male_population
    resource = Indicator.find_by_slug("male-population").resources.where(geo_group_id: id).order(year_from: :desc).first
    resource ? resource.number : 0
  end

end
