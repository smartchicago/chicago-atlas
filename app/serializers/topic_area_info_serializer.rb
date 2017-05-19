class TopicAreaInfoSerializer < ActiveModel::Serializer
  cache key: 'TopicAreaInfo', expires_in: 3.hours

  attributes :id, :category_group_name, :sub_category_name, :indicator, :year_from, :year_to, :demo_group, :number, :cum_number, :ave_annual_number, :crude_rate, :lower_95ci_crude_rate, :upper_95ci_crude_rate, :percent, :lower_95ci_percent, :upper_95ci_percent, :weight_number, :weight_percent, :lower_95ci_weight_percent, :upper_95ci_weight_percent

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
  
  def category_group_name 
    object.category_group.name
  end 

  def sub_category_name
    object.sub_category.name
  end
end
