class Category < ActiveRecord::Base
  has_many :datasets
  attr_accessible :description, :name
end
