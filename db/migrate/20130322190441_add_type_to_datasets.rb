class AddTypeToDatasets < ActiveRecord::Migration
  def change
    add_column :datasets, :type, :string
  end
end
