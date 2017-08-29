class CommunityAreaIndicatorSerializer < ActiveModel::Serializer
  attributes :id, :name, :slug, :area_value, :city_value

  def area_value
    resource = Resource.where(geo_group_id: @instance_options[:geo_id], indicator_id: object.id).order(year_from: :asc).last
    if resource
      source_change_list  = TopicAreaSerializer::SOURCE_CHANGE_LIST
      resource.weight_percent = resource[source_change_list[object.slug]['weight_percent']] if source_change_list[object.slug].present?
    end
    resource
  end

  def city_value
    city_id = GeoGroup.find_by_slug('chicago').id
    demo_id = DemoGroup.find_by_slug('all-race-ethnicitiesrace-ethnicity').id
    resource = Resource.where(geo_group_id: city_id, indicator_id: object.id, demo_group_id: demo_id).order(year_from: :asc).last
    if resource
      source_change_list  = TopicAreaSerializer::SOURCE_CHANGE_LIST
      resource.weight_percent = resource[source_change_list[object.slug]['weight_percent']] if source_change_list[object.slug].present?
    end
    resource
  end
end
