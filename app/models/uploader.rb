class Uploader < ActiveRecord::Base
    mount_uploader :path, ItemUploader
end
