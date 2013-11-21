class ServiceCategory < ActiveRecord::Base
  has_many :intervention_locations, through: :intervention_location_service_categories

  attr_accessible :name
end
