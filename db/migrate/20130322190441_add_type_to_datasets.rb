class AddTypeToDatasets < ActiveRecord::Migration
  def change
    add_column :datasets, :data_type, :string
  end
end
