class Dataset < ActiveRecord::Base
  belongs_to :category
  has_many :statistics

  attr_accessible :description, :metadata, :name, :slug, :provider, :url, :category_id
end
