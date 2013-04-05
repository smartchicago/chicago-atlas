class InterventionLocation < ActiveRecord::Base
  has_many :intervetion_location_datasets

  attr_accessible :name, :hours, :phone, :address, :zip, :latitude, :longitude, :dataset_id
end
