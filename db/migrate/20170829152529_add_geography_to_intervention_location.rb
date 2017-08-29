class AddGeographyToInterventionLocation < ActiveRecord::Migration
  def change
    add_reference :intervention_locations, :geography, index: true, foreign_key: true
  end
end
