class Dataset < ActiveRecord::Base
  belongs_to :category
  has_many :statistics

  attr_accessible :description, :metadata, :name, :slug, :provider, :url, :category_id, :data_type, :stat_type

  def choropleth_cutoffs_json
    if choropleth_cutoffs == ''

      # calculate the cutoffs ourselves. split in to 4 even buckets
      max_value = Statistic.where('dataset_id = ?', id).order('value DESC').first.value
      min_value = Statistic.where('dataset_id = ?', id).order('value').first.value

      range = max_value - min_value
      interval = (range.to_f / 4).round(2)
      
      return [ 0, (min_value + interval), (min_value + (interval*2).round(2)), (min_value + (interval*3).round(2)) ]
    end

    json_cutoffs = ActiveSupport::JSON.decode(choropleth_cutoffs)
  end

  def start_year
    Statistic.select("year")
      .where(:dataset_id => id)
      .order("year ASC").first.year
  end

  def end_year
    Statistic.select("year")
      .where(:dataset_id => id)
      .order("year DESC").first.year
  end
end
