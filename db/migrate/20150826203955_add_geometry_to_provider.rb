class AddGeometryToProvider < ActiveRecord::Migration
  def change
    add_column :providers, :geometry, :text
  end
end
