class CreateUploaders < ActiveRecord::Migration
  def change
    create_table :uploaders do |t|

      t.timestamps null: false
    end
  end
end
