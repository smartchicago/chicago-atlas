class TopicAreaSerializer < ActiveModel::Serializer
  cache key: 'TopicArea', expires_in: 3.hours
  attributes :id, :uploader_path, :indicator, :geo_group_name, :geo_group_part, :demo_group_name, :demography, :number, :cum_number, :ave_annual_number, :crude_rate, :lower_95ci_crude_rate, :upper_95ci_crude_rate, :percent, :lower_95ci_percent, :upper_95ci_percent, :weight_number, :weight_percent, :lower_95ci_weight_percent, :upper_95ci_weight_percent

  def demo_group_name
    object.demo_group.name unless object.demo_group.nil?
  end

  def demography
    object.demo_group.demography unless object.demo_group.nil?
  end    

  def uploader_path
    object.uploader.path
  end

  def geo_group_name
    object.geo_group.name 
  end

  def geo_group_part
    object.geo_group.part 
  end
end
