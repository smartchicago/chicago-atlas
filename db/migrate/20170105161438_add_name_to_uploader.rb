class AddNameToUploader < ActiveRecord::Migration
  def change
    add_column :uploaders, :name, :string
  end
end
