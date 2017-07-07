class Statistic < ActiveRecord::Base
  belongs_to :dataset
  belongs_to :geography
end
