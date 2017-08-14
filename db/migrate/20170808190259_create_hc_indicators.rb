class CreateHcIndicators < ActiveRecord::Migration
  def change
    create_table :hc_indicators do |t|
      t.string :category
      t.string :name
      t.string :most_recent_year
      t.string :priority_population
      t.string :priority_population_most_recent_year
      t.string :target
      t.string :datasource
      t.string :slug
      t.integer :upload_id

      t.timestamps null: false

      t.references :uploader,   index:true, foreign_key: true
    end
  end
end
