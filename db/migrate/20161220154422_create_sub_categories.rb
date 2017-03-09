class CreateSubCategories < ActiveRecord::Migration
  def change
    create_table :sub_categories do |t|
      t.string  :name
      t.integer :category_group_id
      t.string  :slug
      t.references :category_group,   index:true, foreign_key: true
      t.timestamps null: false
    end
  end
end
