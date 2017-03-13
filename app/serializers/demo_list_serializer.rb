class DemoListSerializer < ActiveModel::Serializer
  attributes :name, :demography, :slug

  def slug
    object.demography.downcase
  end
end
