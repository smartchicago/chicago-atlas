class SpreadSheet < ActiveRecord::Base
  mount_uploader :src, ItemUploader
end
