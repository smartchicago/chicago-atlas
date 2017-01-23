class InterventionLocationDataset < ActiveRecord::Base
  belongs_to :datasets
  belongs_to :intervention_locations

  #attr_accessible :intervention_location_id, :dataset_id
end
