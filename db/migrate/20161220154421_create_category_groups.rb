class CreateCategoryGroups < ActiveRecord::Migration
  def change
    create_table :category_groups do |t|
      t.string :name
      t.string :slug
      t.timestamps null: false
    end
  end
end
