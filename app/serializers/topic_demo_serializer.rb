class TopicDemoSerializer < ActiveModel::Serializer
  cache key: 'TopicDemo', expires_in: 3.hour
  attributes :id, :category_group_name,
    :sub_category_name, :indicator,
    :year_from, :year_to, :year, :demo_group,
    :demography, :number, :cum_number,
    :ave_annual_number, :crude_rate,
    :lower_95ci_crude_rate, :upper_95ci_crude_rate,
    :percent, :lower_95ci_percent, :upper_95ci_percent,
    :weight_number, :weight_percent,
    :lower_95ci_weight_percent, :upper_95ci_weight_percent,
    :age_adj_rate

  def demo_group
    object.demo_group.name unless object.demo_group.blank?
  end

  def demography
      object.demo_group.demography unless object.demo_group.blank?
  end

  def category_group_name
    object.category_group.name
  end

  def sub_category_name
    object.sub_category.name
  end

  def crude_rate
    object['crude_rate'].present? ? object['crude_rate'] : object['age_adj_rate']
  end

  def year
    if object.year_from && object.year_to
      object.year_from == object.year_to ? object.year_from : [object.year_from.to_s, object.year_to.to_s].join('-')
    else
      object.year_from
    end
  end
end
