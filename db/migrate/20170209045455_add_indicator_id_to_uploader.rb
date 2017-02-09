class AddIndicatorIdToUploader < ActiveRecord::Migration
  def change
    add_column :uploaders, :indicator_id, :integer
  end
end
