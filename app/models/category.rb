class Category < ActiveRecord::Base
  has_many :resources
end
