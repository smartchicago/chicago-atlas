class AddCategoriesToInterventionLocation < ActiveRecord::Migration
  def change
    add_column :intervention_locations, :categories, :text, :default => ""
  end
end
