class CreateProviders < ActiveRecord::Migration
  def change
    create_table :providers do |t|

      t.integer   :src_id
      t.string    :name
      t.string    :slug
      t.string    :primary_type
      t.string    :sub_type
      t.string    :addr_street
      t.string    :addr_city
      t.string    :addr_zip
      t.string    :ownership_type
      t.string    :contact_email
      t.string    :contact_phone

      t.timestamps null: false

    end

  end
end
