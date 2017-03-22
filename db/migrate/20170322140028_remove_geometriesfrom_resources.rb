class RemoveGeometriesfromResources < ActiveRecord::Migration
  def change
    remove_column :providers, :geometry
  end
end
