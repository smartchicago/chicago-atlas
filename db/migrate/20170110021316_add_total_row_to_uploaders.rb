class AddTotalRowToUploaders < ActiveRecord::Migration
  def change
    add_column :uploaders, :total_row, :integer
  end
end
