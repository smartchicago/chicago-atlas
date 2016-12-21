class Resource < ActiveRecord::Base
  belongs_to :uploader
  belongs_to :category
  belongs_to :demo_group
  belongs_to :geo_group
  belongs_to :indicator
end
