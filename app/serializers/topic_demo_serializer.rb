class TopicDemoSerializer < ActiveModel::Serializer
  attributes :id, :category_group_name, :sub_category_name, :indicator, :year_from, :year_to, :demo_group, :demography, :number, :cum_number, :ave_annual_number, :crude_rate, :lower_95ci_crude_rate, :upper_95ci_crude_rate, :percent, :lower_95ci_percent, :upper_95ci_percent, :weight_number, :weight_percent, :lower_95ci_weight_percent, :upper_95ci_weight_percent

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
end
