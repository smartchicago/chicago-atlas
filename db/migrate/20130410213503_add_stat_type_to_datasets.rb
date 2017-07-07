class AddStatTypeToDatasets < ActiveRecord::Migration
  def change
    add_column :datasets, :stat_type, :string
  end
end
