class Statistic < ActiveRecord::Base
  attr_accessible  :dataset_id, :geography_id, :year, :value, :lower_ci, :upper_ci
end
