class Category < ActiveRecord::Base
  has_many :datasets
end
