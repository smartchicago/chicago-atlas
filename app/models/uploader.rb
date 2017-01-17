class Uploader < ActiveRecord::Base
    mount_uploader :path, ItemUploader
    enum status: [:uploaded, :processing, :completed, :failed]
    has_many :resources, dependent: :destroy
    belongs_to :user

    validates :user_id, presence: true
    validates :name, presence: true
    validates :total_row, presence: true
    validates :current_row, presence: true
    # validates :path, presence: true
end
