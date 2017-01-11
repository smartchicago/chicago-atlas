class Uploader < ActiveRecord::Base
    mount_uploader :path, ItemUploader
    enum status: [:uploaded, :processing, :completed, :failed]
    has_many :resources, dependent: :destroy
    validates :path, presence: true
end
