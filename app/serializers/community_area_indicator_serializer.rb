class CommunityAreaIndicatorSerializer < ActiveModel::Serializer
  attributes :id, :name, :slug, :area_value, :city_value

  def area_value
    Resource.where(geo_group_id: @instance_options[:geo_slug], indicator_id: object.id).last
  end

  def city_value
    city_id = GeoGroup.find_by_slug('chicago').id
    Resource.where(geo_group_id: city_id, indicator_id: object.id).last
  end
end
