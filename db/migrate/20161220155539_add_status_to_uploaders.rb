class AddStatusToUploaders < ActiveRecord::Migration
  def change
    add_column :uploaders, :status, :integer
  end
end
