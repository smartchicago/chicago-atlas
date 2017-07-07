class AddGeoIdToGeoGroup < ActiveRecord::Migration
  def change
    add_column :geo_groups, :geo_id, :integer
  end
end
