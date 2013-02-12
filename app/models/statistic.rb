class Statistic < ActiveRecord::Base
  attr_accessible  :category_id, :geography_id, :stat_type, :slug, :year, :value, :lower_ci, :upper_ci
end
