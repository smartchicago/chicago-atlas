class CreateSpreadSheets < ActiveRecord::Migration
  def change
    create_table :spread_sheets do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
