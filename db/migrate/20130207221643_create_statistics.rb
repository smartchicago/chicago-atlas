class CreateStatistics < ActiveRecord::Migration
  def change
    create_table :statistics do |t|

      t.timestamps
    end
  end
end
