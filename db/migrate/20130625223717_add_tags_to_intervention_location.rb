class AddTagsToInterventionLocation < ActiveRecord::Migration
  def change
    add_column :intervention_locations, :tags, :text, :default => ""
    change_column :intervention_locations, :hours, :text, :default => ""
  end
end
