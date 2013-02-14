class Geography < ActiveRecord::Base
  has_many :statistics

  attr_accessible :geo_type, :name, :external_id, :slug, :geometry
end
