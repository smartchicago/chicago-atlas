class AddNameToIndicatorMapColour < ActiveRecord::Migration
  def change
    add_column :indicator_map_colours, :name, :string
  end
end
