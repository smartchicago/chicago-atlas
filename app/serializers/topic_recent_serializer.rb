class TopicRecentSerializer < ActiveModel::Serializer
  cache key: 'TopicRecent', expires_in: 3.hours
  attributes :id, :category_group_name, :sub_category_name,
    :year_from, :year_to, :demo_group,:percent, :weight_number

  def category_group_name
    object.category_group.name
  end

  def sub_category_name
    object.sub_category.name
  end

end
