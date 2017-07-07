class AddYearRangeToStatistic < ActiveRecord::Migration
  def change
    add_column :statistics, :year_range, :string, :default => ""
  end
end
