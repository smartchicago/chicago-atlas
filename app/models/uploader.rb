class Uploader < ActiveRecord::Base
    mount_uploader :path, ItemUploader
    enum status: [:uploaded, :processing, :completed, :failed]
    has_many :resources, dependent: :destroy
    belongs_to :user

    validates :user_id, presence: true
    validates :name, presence: true
    # validates :path, presence: true

    def initialize_state
      self.update(current_row: 0)
      self.update(total_row: 0)
    end

    def update_current_state(count)
      self.update(current_row: count)
    end

    def update_total_row(count)
      self.update(total_row: count)
    end

    def update_name(name)
      self.update(name: name)
    end

    def remove_resources
      self.resources.delete_all
    end

    def update_indicator(id)
      self.update(indicator_id: id)
    end

end
