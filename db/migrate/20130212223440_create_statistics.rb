class CreateStatistics < ActiveRecord::Migration
  def change
    create_table :statistics do |t|

      t.string :stat_type
      t.string :slug
      t.integer :year
      t.float :value
      t.float :lower_ci
      t.float :upper_ci
      t.references :category
      t.references :geography
      t.timestamps
    end

    add_index :statistics, :geography_id
    add_index :statistics, :category_id
  end
end
