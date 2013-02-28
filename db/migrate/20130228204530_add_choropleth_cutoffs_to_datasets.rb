class AddChoroplethCutoffsToDatasets < ActiveRecord::Migration
  def change
    add_column :datasets, :choropleth_cutoffs, :text, :default => ""
  end
end
