class Geography < ActiveRecord::Base
  attr_accessible :geo_type, :name, :external_id, :slug, :geometry
end
