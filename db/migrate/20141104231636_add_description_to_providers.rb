class AddDescriptionToProviders < ActiveRecord::Migration
  def change
    change_column :providers, :description, :text
  end
end
