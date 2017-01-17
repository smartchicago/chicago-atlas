class Uploader < ActiveRecord::Base
    mount_uploader :path, ItemUploader
    enum status: [:uploaded, :processing, :completed, :failed]
    has_many :resources, dependent: :destroy
    belongs_to :users
    validates :path, presence: true
end
