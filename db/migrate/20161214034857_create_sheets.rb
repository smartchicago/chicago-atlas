class CreateSheets < ActiveRecord::Migration
  def change
    create_table :sheets do |t|
      t.string   :name
      t.string   :src_url
      t.timestamps null: false
    end
  end
end
