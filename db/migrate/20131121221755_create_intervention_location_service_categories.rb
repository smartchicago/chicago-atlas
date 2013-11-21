class CreateInterventionLocationServiceCategories < ActiveRecord::Migration
  def change
    create_table :intervention_location_service_categories do |t|

      t.references :intervention_location
      t.references :service_categories
      t.timestamps
    end
  end
end
