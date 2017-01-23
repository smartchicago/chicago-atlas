class AddChnaLinkToProvider < ActiveRecord::Migration
  def change
    add_column :providers, :chna_url, :string
  end
end
