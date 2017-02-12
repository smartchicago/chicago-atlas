class CategoryGroup < ActiveRecord::Base
  has_many :sub_categories
  validates :name, presence: true
  scope :with_sub_categories, -> { joins(:sub_categories).distinct }
end
