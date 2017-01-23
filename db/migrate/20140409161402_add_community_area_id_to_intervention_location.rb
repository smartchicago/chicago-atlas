class AddCommunityAreaIdToInterventionLocation < ActiveRecord::Migration
  def change
    add_column :intervention_locations, :community_area_id, :integer
  end
end
