class InterventionLocationDataset < ActiveRecord::Base
  belongs_to :datasets
  belongs_to :intervention_locations
end
