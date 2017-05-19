class TopicAreaSerializer < ActiveModel::Serializer
  cache key: 'TopicArea', expires_in: 3.hours
  attributes :id, :uploader_path, :indicator, :geo_group_name, :geo_group_part, :demo_group_name, :demography, :number, :cum_number, :ave_annual_number, :crude_rate, :lower_95ci_crude_rate, :upper_95ci_crude_rate, :percent, :lower_95ci_percent, :upper_95ci_percent, :weight_number, :weight_percent, :lower_95ci_weight_percent, :upper_95ci_weight_percent

  SOURCE_CHANGE_LIST = {
    'accidents' => {
      'weight_number'  => 'number',
      'weight_percent' => 'age_adj_rate'      
    },
    'alcohol-induced-deaths' => {
      'weight_number'  => 'number',
      'weight_percent' => 'age_adj_rate'      
    },
    'alzheimers-disease' => {
      'weight_number'  => 'number',
      'weight_percent' => 'age_adj_rate'      
    }
  }

  CI_CHANGE_LIST = {
    'accidents' => {
      'lower_95ci_weight_percent'  => 'lower_95ci_adj_rate',
      'upper_95ci_weight_percent'  => 'upper_95ci_adj_rate'      
    },
    'alcohol-induced-deaths' => {
      'lower_95ci_weight_percent'  => 'lower_95ci_adj_rate',
      'upper_95ci_weight_percent'  => 'upper_95ci_adj_rate'      
    },
    'alzheimers-disease' => {
      'lower_95ci_weight_percent'  => 'lower_95ci_adj_rate',
      'upper_95ci_weight_percent'  => 'upper_95ci_adj_rate'      
    }
  }

  def weight_number
    SOURCE_CHANGE_LIST[object.indicator.slug].present? ? object[SOURCE_CHANGE_LIST[object.indicator.slug]['weight_number']] : object.weight_number
  end 

  def weight_percent 
    SOURCE_CHANGE_LIST[object.indicator.slug].present? ? object[SOURCE_CHANGE_LIST[object.indicator.slug]['weight_percent']] : object.weight_percent
  end 

  def lower_95ci_adj_rate 
    CI_CHANGE_LIST[object.indicator.slug].present? ? object[CI_CHANGE_LIST[object.indicator.slug]['lower_95ci_adj_rate']] : object.lower_95ci_adj_rate
  end 
  
  def upper_95ci_adj_rate
    CI_CHANGE_LIST[object.indicator.slug].present? ? object[CI_CHANGE_LIST[object.indicator.slug]['upper_95ci_adj_rate']] : object.upper_95ci_adj_rate
  end 
  
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
