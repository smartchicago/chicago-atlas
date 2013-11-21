class CreateServiceCategories < ActiveRecord::Migration
  def change
    create_table :service_categories do |t|

      t.string :name
      t.timestamps
    end
  end
end
