class AddCommunityAreaNameToInterventionLocation < ActiveRecord::Migration
  def change
    add_column :intervention_locations, :community_area_name, :string
  end
end
