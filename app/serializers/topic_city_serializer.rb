class TopicCitySerializer < ActiveModel::Serializer
  attributes :id, :uploader_path, :indicator, :demo_group_name, :demography, :number, :cum_number, :ave_annual_number, :crude_rate, :lower_95ci_crude_rate, :upper_95ci_crude_rate, :percent, :lower_95ci_percent, :upper_95ci_percent, :weight_number, :weight_percent, :lower_95ci_weight_percent, :upper_95ci_weight_percent

  def demo_group_name
    object.demo_group.name
  end

  def demography
    object.demo_group.demography
  end    

  def uploader_path
    object.uploader.path
  end
end
