class CreateProviderStats < ActiveRecord::Migration
  def change
    create_table :provider_stats do |t|

    	t.integer :src_id
    	t.string :stat_type
    	t.string :stat
    	t.float :value
    	t.integer :year
    	t.string :time_period

    	t.timestamps
    end
    add_index :provider_stats, :src_id
  end
end
