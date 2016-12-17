class AddItemToSpreadSheets < ActiveRecord::Migration
  def change
    add_column :spread_sheets, :src, :string
  end
end
