class CreateAreaParts < ActiveRecord::Migration
  def change
    create_table :area_parts do |t|
      t.string :name
      t.string :part

      t.timestamps null: false
    end
  end
end
