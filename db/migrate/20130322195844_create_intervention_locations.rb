class CreateInterventionLocations < ActiveRecord::Migration
  def change
    create_table :intervention_locations do |t|

      t.string :name
      t.string :hours
      t.string :phone
      t.string :address
      t.string :city
      t.string :state
      t.string :zip
      t.float  :latitude
      t.float  :longitude
      t.references :dataset
      t.timestamps
    end
  end
end
