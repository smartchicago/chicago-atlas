class AddProgramNameToInterventionLocations < ActiveRecord::Migration
  def up
    add_column :intervention_locations, :organization_name, :string, :default => ""
    rename_column :intervention_locations, :name, :program_name
  end

  def down
    remove_column :intervention_locations, :organization_name
    rename_column :intervention_locations, :program_name, :name
  end
end
