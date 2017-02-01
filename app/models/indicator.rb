class Indicator < ActiveRecord::Base
  has_many :resources
  belongs_to :SubCategory
  validates :name, presence: true
end
