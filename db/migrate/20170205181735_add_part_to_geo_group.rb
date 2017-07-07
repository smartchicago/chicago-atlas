class AddPartToGeoGroup < ActiveRecord::Migration
  def change
    add_column :geo_groups, :part, :string
  end
end
