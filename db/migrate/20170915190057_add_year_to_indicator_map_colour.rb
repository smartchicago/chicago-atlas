class AddYearToIndicatorMapColour < ActiveRecord::Migration
  def change
    add_column :indicator_map_colours, :year, :string
  end
end
