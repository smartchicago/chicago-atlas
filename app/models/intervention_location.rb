class InterventionLocation < ActiveRecord::Base
  attr_accessible :name, :hours, :phone, :address, :zip, :latitude, :longitude, :dataset_id
end
