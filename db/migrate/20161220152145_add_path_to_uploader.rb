class AddPathToUploader < ActiveRecord::Migration
  def change
    add_column :uploaders, :path, :string
  end
end
