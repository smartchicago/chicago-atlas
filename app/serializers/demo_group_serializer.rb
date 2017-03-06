class DemoGroupSerializer < ActiveModel::Serializer
  attributes :id, :demography, :name
  has_many :resources
end
