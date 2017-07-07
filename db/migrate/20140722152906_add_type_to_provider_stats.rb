class AddTypeToProviderStats < ActiveRecord::Migration
  def change
    add_column :provider_stats, :data_type, :string
  end
end
