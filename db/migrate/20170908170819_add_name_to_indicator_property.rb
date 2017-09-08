class AddNameToIndicatorProperty < ActiveRecord::Migration
  def change
    add_column :indicator_properties, :name, :string
  end
end
