class SubCategory < ActiveRecord::Base
  belongs_to :category_group
  has_many :indicators

  SLUG_INDICES = 'indices'

  scope :exclude_indices, -> { where.not('sub_categories.slug': SLUG_INDICES) }
  scope :with_indicators, -> { exclude_indices.joins(:indicators).distinct }
end
