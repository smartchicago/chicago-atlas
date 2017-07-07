class DemoGroupSerializer < ActiveModel::Serializer
  attributes :id, :demography, :name, :slug
  has_many :resources
end
