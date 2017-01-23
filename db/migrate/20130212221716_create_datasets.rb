class CreateDatasets < ActiveRecord::Migration
  def change
    create_table :datasets do |t|
      t.string :name
      t.string :slug
      t.text :description
      t.string :provider
      t.string :url
      t.text :metadata
      t.references :category

      t.timestamps
    end

    add_index :datasets, :category_id
  end
end
