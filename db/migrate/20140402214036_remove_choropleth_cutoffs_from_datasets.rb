class RemoveChoroplethCutoffsFromDatasets < ActiveRecord::Migration
  def change
    remove_column :datasets, :choropleth_cutoffs
  end
end
