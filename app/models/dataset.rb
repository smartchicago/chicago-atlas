require 'csv'

class Dataset < ActiveRecord::Base
  belongs_to :category
  has_many :statistics

  #attr_accessible :description, :metadata, :name, :slug, :provider, :url, :category_id, :data_type, :stat_type

  def start_year
    self.year_range.first.year
  end

  def end_year
    self.year_range.last.year
  end

  def year_range
    Statistic.select("DISTINCT(year)")
      .where(:dataset_id => id)
      .order("year ASC")
  end

  def areas
    Statistic.select("DISTINCT(geography_id)")
      .where(:dataset_id => id)
      .order("geography_id ASC")
  end

  def to_csv
    year_range = self.year_range
    areas = self.areas
    headers = ["geographic area"]

    year_range.each do |y|
      headers.append(y.year)
    end

    CSV.generate do |csv|
      csv << headers

      # Iterate through every geographic area
      areas.each do |area_id|

        # Skip area id 99, it's a catch-all id that doesn't correspond to any
        # real geographic areas in the city.
        if area_id.geography_id != 99 and area_id.geography_id != 60633
          row = []
          row.append(Geography.select("name").where(:id => area_id.geography_id).first.name)

          # Iterate through every dataset year
          year_range.each do |y|

            stat = Statistic.select("value").where(:dataset_id => id, :geography_id => area_id.geography_id, :year => y.year).first.value
            if stat.nil?
              row.append("")
            else
              row.append(stat)
            end
          end

          csv << row
        end

      end

    end
  end

end
