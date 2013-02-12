class Dataset < ActiveRecord::Base
  attr_accessible :description, :metadata, :name, :slug, :provider, :url, :category_id
end
