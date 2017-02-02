class Indicator < ActiveRecord::Base
  has_many :resources
  belongs_to :sub_category
  validates :name, presence: true
end
