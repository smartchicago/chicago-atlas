class AddAdjacentGeographiesToGeography < ActiveRecord::Migration
  def change
    add_column :geographies, :adjacent_zips, :string, :default => "[]"
    add_column :geographies, :adjacent_community_areas, :string, :default => "[]"
  end
end
