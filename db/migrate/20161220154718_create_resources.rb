class CreateResources < ActiveRecord::Migration
  def change
    create_table :resources do |t|
      t.integer :uploader_id
      t.integer :category_id
      t.integer :sub_category_id
      t.integer :indicator_id
      t.integer :year
      t.integer :geo_group_id
      t.integer :demo_group_id
      t.integer :number
      t.float   :cum_number
      t.float   :ave_annual_number
      t.float   :crude_rate
      t.float   :lower_95ci_crude_rate
      t.float   :uppper_95ci_crude_rate
      t.float   :age_adj_rate
      t.float   :lower_95ci_adj_rate
      t.float   :upper_95ci_adj_rate
      t.float   :percent
      t.float   :lower_95ci_percent
      t.float   :upper_95ci_percent
      t.float   :weight_number
      t.float   :weight_percent
      t.float   :lower_95ci_weight_percent
      t.float   :upper_95ci_weight_percent
      t.string  :map_key
      t.string  :flag

      t.timestamps null: false
    end
  end
end
