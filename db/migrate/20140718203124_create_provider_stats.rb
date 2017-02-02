class CreateProviderStats < ActiveRecord::Migration
  def change
    create_table :provider_stats do |t|

    	t.references   :provider
    	t.string       :stat_type
    	t.string       :stat
    	t.float        :value
    	t.datetime     :date_start
    	t.datetime     :date_end

    	t.timestamps null: false
    end
    add_index :provider_stats, :provider_id
    add_index :provider_stats, :stat_type
  end
end
