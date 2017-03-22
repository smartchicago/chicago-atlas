class SubCategorySerializer < ActiveModel::Serializer
  attributes :id, :name, :slug, :indicators
  has_many :indicators
end
