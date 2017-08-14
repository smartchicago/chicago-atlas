class AddCategoryToUploader < ActiveRecord::Migration
  def change
    add_column :uploaders, :is_health_care_indicators, :boolean, default: false
  end
end
