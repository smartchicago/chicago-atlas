class Dataset < ActiveRecord::Base
  belongs_to :category
  has_many :statistics

  attr_accessible :description, :metadata, :name, :slug, :provider, :url, :category_id, :data_type, :stat_type

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
