class AddLatLongToProviders < ActiveRecord::Migration
  def change
    add_column :providers, :lat_long, :string
  end
end
