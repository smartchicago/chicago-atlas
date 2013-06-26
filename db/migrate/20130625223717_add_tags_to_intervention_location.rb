class AddTagsToInterventionLocation < ActiveRecord::Migration
  def up
    add_column :intervention_locations, :tags, :text, :default => ""
    change_column :intervention_locations, :hours, :text, :default => ""
  end

  def down
    remove_column :intervention_locations, :tags
    change_column :intervention_locations, :hours, :string, :default => ""
  end
end
