class CreateDemoGroups < ActiveRecord::Migration
  def change
    create_table :demo_groups do |t|
      t.string :name
      t.string :demography
      t.string :slug
      t.timestamps null: false
    end
  end
end
