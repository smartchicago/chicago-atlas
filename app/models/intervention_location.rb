class InterventionLocation < ActiveRecord::Base
  has_many :intervetion_location_datasets
  has_many :service_categories, through: :intervention_location_service_categories
  belongs_to :geography
end
