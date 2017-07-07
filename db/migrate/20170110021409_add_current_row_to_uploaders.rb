class AddCurrentRowToUploaders < ActiveRecord::Migration
  def change
    add_column :uploaders, :current_row, :integer
  end
end
