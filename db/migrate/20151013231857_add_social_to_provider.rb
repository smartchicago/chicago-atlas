class AddSocialToProvider < ActiveRecord::Migration
  def change
    add_column :providers, :twitter, :string
    add_column :providers, :facebook, :string
  end
end
