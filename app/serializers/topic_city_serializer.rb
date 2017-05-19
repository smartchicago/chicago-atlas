class TopicCitySerializer < ActiveModel::Serializer
  cache key: 'TopicCity', expires_in: 3.hours
  attributes :id, :uploader_path, :indicator, :demo_group_name, :demography, :number, :cum_number, :ave_annual_number, :crude_rate, :lower_95ci_crude_rate, :upper_95ci_crude_rate, :percent, :lower_95ci_percent, :upper_95ci_percent, :weight_number, :weight_percent, :lower_95ci_weight_percent, :upper_95ci_weight_percent

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
    },
    'cancer-deaths' => {
      'weight_number'  => 'number',
      'weight_percent' => 'age_adj_rate'      
    },
    'cancer-incidence' => {
      'weight_number'  => 'ave_annual_number',
      'weight_percent' => 'age_adj_rate'      
    },
    'cervical-cancer-deaths' => {
      'weight_number'  => 'number',
      'weight_percent' => 'age_adj_rate'      
    },
    'cervical-cancer-incidence' => {
      'weight_number'  => 'ave_annual_number',
      'weight_percent' => 'age_adj_rate'      
    },
    'cesarean-delivery' => {
      'weight_number'  => 'number',
      'weight_percent' => 'percent'      
    },
    'child-obesity' => {
      'weight_number'  => 'number',
      'weight_percent' => 'age_adj_rate'      
    },
    'chlamydia' => {
      'weight_number'  => 'number',
      'weight_percent' => 'crude_rate'      
    },
    'chronic-liver-disease-and-cirrhosis-deaths' => {
      'weight_number'  => 'number',
      'weight_percent' => 'age_adj_rate'      
    },
    'chronic-lower-respiratory-disease-deaths' => {
      'weight_number'  => 'number',
      'weight_percent' => 'age_adj_rate'      
    },
    'colorectal-cancer-deaths' => {
      'weight_number'  => 'number',
      'weight_percent' => 'age_adj_rate'      
    },
    'coronary-heart-disease-deaths' => {
      'weight_number'  => 'number',
      'weight_percent' => 'age_adj_rate'      
    },
    'crude-birth-rate' => {
      'weight_number'  => 'number',
      'weight_percent' => 'crude_rate'      
    },
    'diabetes-deaths' => {
      'weight_number'  => 'number',
      'weight_percent' => 'age_adj_rate'      
    },
    'diabetes-related-deaths' => {
      'weight_number'  => 'number',
      'weight_percent' => 'age_adj_rate'      
    },
    'diet-related-deaths' => {
      'weight_number'  => 'number',
      'weight_percent' => 'age_adj_rate'      
    },
    'drug-overdose-deaths' => {
      'weight_number'  => 'number',
      'weight_percent' => 'age_adj_rate'      
    },
    'drug-induced-deaths' => {
      'weight_number'  => 'number',
      'weight_percent' => 'age_adj_rate'      
    },
    'early-and-adequate-prenatal-care' => {
      'weight_number'  => 'number',
      'weight_percent' => 'percent'      
    },
    'engagement-in-hiv-care' => {
      'weight_number'  => 'number',
      'weight_percent' => 'percent'      
    },
    'female-breast-cancer-deaths' => {
      'weight_number'  => 'number',
      'weight_percent' => 'age_adj_rate'      
    },
    'female-breast-cancer-incidence' => {
      'weight_number'  => 'ave_annual_number',
      'weight_percent' => 'age_adj_rate'      
    },
    'firearm-related-homicides' => {
      'weight_number'  => 'number',
      'weight_percent' => 'age_adj_rate'      
    },
    'firearm-related-homicides-by-injury-location' => {
      'weight_number'  => 'number',
      'weight_percent' => 'crude_rate'      
    },
    'general-fertility-rate' => {
      'weight_number'  => 'number',
      'weight_percent' => 'crude_rate'      
    },
    'gonorrhea' => {
      'weight_number'  => 'number',
      'weight_percent' => 'crude_rate'      
    },
    'heart-disease-deaths' => {
      'weight_number'  => 'number',
      'weight_percent' => 'age_adj_rate'      
    },
    'hiv-incidence' => {
      'weight_number'  => 'number',
      'weight_percent' => 'crude_rate'      
    },
    'hiv-prevalence' => {
      'weight_number'  => 'number',
      'weight_percent' => 'crude_rate'      
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
    },
    'cancer-deaths' => {
      'lower_95ci_weight_percent'  => 'lower_95ci_adj_rate',
      'upper_95ci_weight_percent'  => 'upper_95ci_adj_rate'      
    },
    'cancer-incidence' => {
      'lower_95ci_weight_percent'  => 'lower_95ci_adj_rate',
      'upper_95ci_weight_percent'  => 'upper_95ci_adj_rate'      
    },
    'cervical-cancer-deaths' => {
      'lower_95ci_weight_percent'  => 'lower_95ci_adj_rate',
      'upper_95ci_weight_percent'  => 'upper_95ci_adj_rate'      
    },
    'cervical-cancer-incidence' => {
      'lower_95ci_weight_percent'  => 'lower_95ci_adj_rate',
      'upper_95ci_weight_percent'  => 'upper_95ci_adj_rate'      
    },
    'cesarean-delivery' => {
      'lower_95ci_weight_percent'  => 'lower_95ci_percent',
      'upper_95ci_weight_percent'  => 'upper_95ci_percent'      
    },
    'child-obesity' => {
      'lower_95ci_weight_percent'  => 'lower_95ci_weight_percent',
      'upper_95ci_weight_percent'  => 'upper_95ci_weight_percent'      
    },
    'chlamydia' => {
      'lower_95ci_weight_percent'  => 'lower_95ci_crude_rate',
      'upper_95ci_weight_percent'  => 'upper_95ci_crude_rate'      
    },
    'chronic-liver-disease-and-cirrhosis-deaths' => {
      'lower_95ci_weight_percent'  => 'lower_95ci_adj_rate',
      'upper_95ci_weight_percent'  => 'upper_95ci_adj_rate'      
    },
    'chronic-lower-respiratory-disease-deaths' => {
      'lower_95ci_weight_percent'  => 'lower_95ci_adj_rate',
      'upper_95ci_weight_percent'  => 'upper_95ci_adj_rate'      
    },
    'colorectal-cancer-deaths' => {
      'lower_95ci_weight_percent'  => 'lower_95ci_adj_rate',
      'upper_95ci_weight_percent'  => 'upper_95ci_adj_rate'      
    },
    'coronary-heart-disease-deaths' => {
      'lower_95ci_weight_percent'  => 'lower_95ci_adj_rate',
      'upper_95ci_weight_percent'  => 'upper_95ci_adj_rate'      
    },
    'crude-birth-rate' => {
      'lower_95ci_weight_percent'  => 'lower_95ci_crude_rate',
      'upper_95ci_weight_percent'  => 'upper_95ci_crude_rate'      
    },
    'diabetes-deaths' => {
      'lower_95ci_weight_percent'  => 'lower_95ci_adj_rate',
      'upper_95ci_weight_percent'  => 'upper_95ci_adj_rate'      
    },
    'diabetes-related-deaths' => {
      'lower_95ci_weight_percent'  => 'lower_95ci_adj_rate',
      'upper_95ci_weight_percent'  => 'upper_95ci_adj_rate'      
    },
    'diet-related-deaths' => {
      'lower_95ci_weight_percent'  => 'lower_95ci_adj_rate',
      'upper_95ci_weight_percent'  => 'upper_95ci_adj_rate'      
    },
    'drug-overdose-deaths' => {
      'lower_95ci_weight_percent'  => 'lower_95ci_adj_rate',
      'upper_95ci_weight_percent'  => 'upper_95ci_adj_rate'      
    },
    'drug-induced-deaths' => {
      'lower_95ci_weight_percent'  => 'lower_95ci_adj_rate',
      'upper_95ci_weight_percent'  => 'upper_95ci_adj_rate'      
    },
    'early-and-adequate-prenatal-care' => {
      'lower_95ci_weight_percent'  => 'lower_95ci_percent',
      'upper_95ci_weight_percent'  => 'upper_95ci_percent'      
    },
    'engagement-in-hiv-care' => {
      'lower_95ci_weight_percent'  => 'lower_95ci_percent',
      'upper_95ci_weight_percent'  => 'upper_95ci_percent'      
    },
    'female-breast-cancer-deaths' => {
      'lower_95ci_weight_percent'  => 'lower_95ci_adj_rate',
      'upper_95ci_weight_percent'  => 'upper_95ci_adj_rate'      
    },
    'female-breast-cancer-incidence' => {
      'lower_95ci_weight_percent'  => 'lower_95ci_adj_rate',
      'upper_95ci_weight_percent'  => 'upper_95ci_adj_rate'      
    },
    'firearm-related-homicides' => {
      'lower_95ci_weight_percent'  => 'lower_95ci_adj_rate',
      'upper_95ci_weight_percent'  => 'upper_95ci_adj_rate'      
    },
    'firearm-related-homicides-by-injury-location' => {
      'lower_95ci_weight_percent'  => 'lower_95ci_crude_rate',
      'upper_95ci_weight_percent'  => 'upper_95ci_crude_rate'      
    },
    'general-fertility-rate' => {
      'lower_95ci_weight_percent'  => 'lower_95ci_crude_rate',
      'upper_95ci_weight_percent'  => 'upper_95ci_crude_rate'      
    },
    'gonorrhea' => {
      'lower_95ci_weight_percent'  => 'lower_95ci_crude_rate',
      'upper_95ci_weight_percent'  => 'upper_95ci_crude_rate'      
    },
    'heart-disease-deaths' => {
      'lower_95ci_weight_percent'  => 'lower_95ci_adj_rate',
      'upper_95ci_weight_percent'  => 'upper_95ci_adj_rate'      
    },
    'hiv-incidence' => {
      'lower_95ci_weight_percent'  => 'lower_95ci_crude_rate',
      'upper_95ci_weight_percent'  => 'upper_95ci_crude_rate'      
    },
    'hiv-prevalence' => {
      'lower_95ci_weight_percent'  => 'lower_95ci_crude_rate',
      'upper_95ci_weight_percent'  => 'upper_95ci_crude_rate'      
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
end
