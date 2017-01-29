class CreateUploaders < ActiveRecord::Migration
  def change
    create_table :uploaders do |t|
      t.references :user, index: true, foreign_key: true
      t.string :comment
      t.timestamps null: false
    end
  end
end
