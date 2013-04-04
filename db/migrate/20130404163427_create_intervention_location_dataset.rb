class CreateInterventionLocationDataset < ActiveRecord::Migration
  def change
    create_table :intervention_location_dataset do |t|
      t.references :intervention_location
      t.references :dataset
    end

    add_index :intervention_location_dataset, [:intervention_location_id, :dataset_id], :name => 'index_intervention_location_dataset_idx'
  end
end
