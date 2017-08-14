class AddDataSourceURlToHcIndicators < ActiveRecord::Migration
  def change
    add_column :hc_indicators, :datasource_url, :string
  end
end
