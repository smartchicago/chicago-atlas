class Statistic < ActiveRecord::Base
  belongs_to :dataset
  belongs_to :geography

  attr_accessible  :dataset_id, :geography_id, :year, :year_range, :name, :value, :lower_ci, :upper_ci
end
