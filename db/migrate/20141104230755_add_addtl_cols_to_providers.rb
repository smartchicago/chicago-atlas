class AddAddtlColsToProviders < ActiveRecord::Migration
  def change
    add_column :providers, :description, :string
    add_column :providers, :phone, :string
    add_column :providers, :url, :string
    add_column :providers, :report_url, :string
    add_column :providers, :report_name, :string
  end
end
