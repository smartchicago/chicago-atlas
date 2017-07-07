class AddIsVisibleToDatasets < ActiveRecord::Migration
  def change
    add_column :datasets, :is_visible, :boolean, :default => true
  end
end
