class InterventionLocationServiceCategory < ActiveRecord::Base
  has_many :intervention_locations
  has_many :service_categories

  attr_accessible :intervention_location_id, :service_categories_id
end
