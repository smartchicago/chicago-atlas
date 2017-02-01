class SubCategorySerializer < ActiveModel::Serializer
  attributes :id, :name, :indicators
  has_many :indicators
end
