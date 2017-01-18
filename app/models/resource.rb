class Resource < ActiveRecord::Base
  belongs_to :uploader
  belongs_to :category
  belongs_to :demo_group
  belongs_to :geo_group
  belongs_to :indicator

  validates :uploader_id, presence: true
  validates :category_id, presence: true
  validates :indicator_id, presence: true
  validates :geo_group_id, presence: true
  validates :demo_group_id, presence: true
end
