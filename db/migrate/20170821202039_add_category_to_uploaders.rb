class AddCategoryToUploaders < ActiveRecord::Migration
  def change
    remove_column :uploaders, :is_health_care_indicators
    add_column :uploaders, :category, :integer, default: 0
  end
end
