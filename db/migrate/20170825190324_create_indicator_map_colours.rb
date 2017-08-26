class CreateIndicatorMapColours < ActiveRecord::Migration
  def change
    create_table :indicator_map_colours do |t|
      t.string :slug
      t.string :map_key
      t.string :start_value
      t.string :end_value
      t.string :colour

      t.timestamps null: false
    end
  end
end
