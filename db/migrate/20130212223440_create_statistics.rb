class CreateStatistics < ActiveRecord::Migration
  def change
    create_table :statistics do |t|

      t.integer :year
      t.string :name
      t.float :value
      t.float :lower_ci
      t.float :upper_ci
      t.references :geography
      t.references :dataset
      t.timestamps
    end

    add_index :statistics, :dataset_id
    add_index :statistics, :geography_id
  end
end
