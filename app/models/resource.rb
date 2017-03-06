class Resource < ActiveRecord::Base
  belongs_to :uploader
  belongs_to :category_group
  belongs_to :sub_category
  belongs_to :demo_group
  belongs_to :geo_group
  belongs_to :indicator

  validates :uploader_id, presence: true

end
