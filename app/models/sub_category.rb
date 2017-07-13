class SubCategory < ActiveRecord::Base
  belongs_to :category_group
  has_many :indicators
  scope :with_indicators, -> { joins(:indicators).where.not('indicators.slug': ['child-opportunity-index','economic-hardship']).distinct }
end
