class ResourceIndicesSerializer < ActiveModel::Serializer
  attributes :area, :slug, :value

  def value
    object.demo_group.try(:name) || ''
  end

  def area
    object.geo_group.try(:name) || ''
  end

  def slug
    object.geo_group.try(:slug) || ''
  end

end
