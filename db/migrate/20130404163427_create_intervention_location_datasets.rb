class CreateInterventionLocationDatasets < ActiveRecord::Migration
  def change
    create_table :intervention_location_datasets do |t|
      t.references :intervention_location
      t.references :dataset
    end

    add_index :intervention_location_datasets, [:intervention_location_id, :dataset_id], :name => 'index_intervention_location_dataset_idx'
  end
end
