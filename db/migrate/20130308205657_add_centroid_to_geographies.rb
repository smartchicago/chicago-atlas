class AddCentroidToGeographies < ActiveRecord::Migration
  def change
    add_column :geographies, :centroid, :string
  end
end
