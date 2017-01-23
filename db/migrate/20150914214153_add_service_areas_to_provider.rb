class AddServiceAreasToProvider < ActiveRecord::Migration
  def change
    add_column :providers, :areas, :text
    add_column :providers, :area_type, :string
    add_column :providers, :area_alt, :text
  end
end
