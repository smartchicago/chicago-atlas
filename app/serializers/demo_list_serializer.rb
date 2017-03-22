class DemoListSerializer < ActiveModel::Serializer
  cache key: 'DemoList', expires_in: 3.hours
  attributes :name, :demography, :slug

  def slug
    object.demography.downcase
  end
end
