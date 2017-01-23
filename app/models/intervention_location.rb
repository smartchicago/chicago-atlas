class InterventionLocation < ActiveRecord::Base
  has_many :intervetion_location_datasets
  has_many :service_categories, through: :intervention_location_service_categories

  #attr_accessible :organization_name, :program_name, :hours, :phone, :tags, :categories, :address, :city, :state, :zip, :community_area_id, :latitude, :longitude, :dataset_id, :purple_binder_url, :program_url
end
