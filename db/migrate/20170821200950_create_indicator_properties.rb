class CreateIndicatorProperties < ActiveRecord::Migration
  def change
    create_table :indicator_properties do |t|
      t.string :slug
      t.string :order
      t.string :description

      t.timestamps null: false

    end
  end
end
