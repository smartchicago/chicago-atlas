class CategoryGroup < ActiveRecord::Base
  has_many :SubCategory
  validates :name, presence: true
end
