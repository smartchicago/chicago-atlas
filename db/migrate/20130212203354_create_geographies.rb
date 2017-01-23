class CreateGeographies < ActiveRecord::Migration
  def change
    create_table :geographies do |t|

      t.string :geo_type
      t.string :name
      t.string :slug
      t.text :geometry
      t.timestamps
    end
  end
end
