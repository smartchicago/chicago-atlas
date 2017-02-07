class AddPartToGeography < ActiveRecord::Migration
  def change
    add_column :geographies, :part, :string
  end
end
