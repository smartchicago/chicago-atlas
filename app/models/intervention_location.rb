class InterventionLocation < ActiveRecord::Base
  has_many :intervetion_location_datasets

  attr_accessible :organization_name, :program_name, :hours, :phone, :tags, :address, :city, :state, :zip, :latitude, :longitude, :dataset_id
end
