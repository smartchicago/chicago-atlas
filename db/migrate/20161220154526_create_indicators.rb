class CreateIndicators < ActiveRecord::Migration
  def change
    create_table :indicators do |t|
      t.string :name
      t.integer :sub_category_id
      t.references :sub_category, index:true, foreign_key: true
      t.string :slug
      t.timestamps null: false
    end
  end
end
