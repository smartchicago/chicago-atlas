class SubCategory < ActiveRecord::Base
  belongs_to :category_group
  has_many :indicators
end
