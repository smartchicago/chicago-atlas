class CreatePartners < ActiveRecord::Migration
  def change
    create_table :partners do |t|
      t.string :title
      t.string :description
      t.string :img_src_url
      t.string :img_alt
      t.string :image_url

      t.timestamps null: false
    end
  end
end
