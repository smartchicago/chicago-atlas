class TopicCityInfoSerializer < ActiveModel::Serializer
  cache key: 'TopicCityInfo', expires_in: 3.hours

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
  },
  'homocides' => {
    'weight_number'  => 'number',
    'weight_percent' => 'age_adj_rate'
  },
  'influenza-and-pneumonia-deaths' => {
    'weight_number'  => 'number',
    'weight_percent' => 'age_adj_rate'
  },
  'injury-deaths' => {
    'weight_number'  => 'number',
    'weight_percent' => 'age_adj_rate'
  },
  'late-stage-female-breast-cancer-incidence' => {
    'weight_number'  => 'Ave_annual_number',
    'weight_percent' => 'age_adj_rate'
  },
  'lead-poisoning' => {
    'weight_number'  => 'number',
    'weight_percent' => 'crude_rate'
  },
  'linkage-to-hiv-care' => {
    'weight_number'  => 'number',
    'weight_percent' => 'Percent'
  },
  'low-birthweight' => {
    'weight_number'  => 'number',
    'weight_percent' => 'Percent'
  },
  'lung-cancer-deaths' => {
    'weight_number'  => 'number',
    'weight_percent' => 'Age_Adj_Rate'
  },
  'lung-cancer-incidence' => {
    'weight_number'  => 'Ave_annual_number',
    'weight_percent' => 'Age_Adj_Rate'
  },
  'motor-vehicle-crash-deaths' => {
    'weight_number'  => 'number',
    'weight_percent' => 'Age_Adj_Rate'
  },
  'nephritis-nephrotic-syndrome-and-nephrosis-deaths' => {
    'weight_number'  => 'number',
    'weight_percent' => 'Age_Adj_Rate'
  },
  'opioid-related-overdose-deaths' => {
    'weight_number'  => 'number',
    'weight_percent' => 'Age_Adj_Rate'
  },
  'prenatal-care-in-first-trimester' => {
    'weight_number'  => 'number',
    'weight_percent' => 'Percent'
  },
  'primary-care-provider' => {
    'weight_number'  => 'weight_number',
    'weight_percent' => 'weight_percent'
  },
  'prenatal-care-in-first-trimester' => {
    'weight_number'  => 'number',
    'weight_percent' => 'Percent'
  },
  'prostate-cancer-deaths' => {
    'weight_number'  => 'number',
    'weight_percent' => 'Age_Adj_Rate'
  },
  'prostate-cancer-incidence' => {
    'weight_number'  => 'Ave_annual_number',
    'weight_percent' => 'Age_Adj_Rate'
  },
  'routine-checkup' => {
    'weight_number'  => 'weight_number',
    'weight_percent' => 'weight_percent'
  },
  'smoking-during-pregnancy' => {
    'weight_number'  => 'number',
    'weight_percent' => 'Percent'
  },
  'suicide' => {
    'weight_number'  => 'number',
    'weight_percent' => 'Age_Adj_Rate'
  },
  'syphilis' => {
    'weight_number'  => 'number',
    'weight_percent' => 'Crude_Rate'
  },
  'teen-birth-rate' => {
    'weight_number'  => 'number',
    'weight_percent' => 'Crude_Rate'
  },
  'tobacco-related-deaths' => {
    'weight_number'  => 'number',
    'weight_percent' => 'Age_Adj_Rate'
  },
  'total-fertility-rate' => {
    'weight_number'  => 'number',
    'weight_percent' => 'Age_Adj_Rate'
  },
  'twin-birth-rate' => {
    'weight_number'  => 'number',
    'weight_percent' => 'Crude_Rate'
  },
  'varicella' => {
    'weight_number'  => 'number',
    'weight_percent' => 'Crude_Rate'
  },
  'ypll' => {
    'weight_number'  => 'number',
    'weight_percent' => 'Crude_Rate'
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
'homicides' => {
  'lower_95ci_weight_percent'  => 'Lower_95CI_Age_Adj_Rate',
  'upper_95ci_weight_percent'  => 'Upper_95CI_Age_Adj_Rate'
},
'infant-mortality' => {
  'lower_95ci_weight_percent'  => 'Lower_95CI_Crude_Rate',
  'upper_95ci_weight_percent'  => 'Upper_95CI_Crude_Rate'
},
'influenza-pneumonia-deaths' => {
  'lower_95ci_weight_percent'  => 'Lower_95CI_Age_Adj_Rate',
  'upper_95ci_weight_percent'  => 'Upper_95CI_Age_Adj_Rate'
},
'injury-deaths' => {
  'lower_95ci_weight_percent'  => 'Lower_95CI_Age_Adj_Rate',
  'upper_95ci_weight_percent'  => 'Upper_95CI_Age_Adj_Rate'
},
'late-stage-female-breast-cancer-incidence' => {
  'lower_95ci_weight_percent'  => 'Lower_95CI_Age_Adj_Rate',
  'upper_95ci_weight_percent'  => 'Upper_95CI_Age_Adj_Rate'
},
'lead-poisoning' => {
  'lower_95ci_weight_percent'  => 'Lower_95CI_Crude_Rate',
  'upper_95ci_weight_percent'  => 'Upper_95CI_Crude_Rate'
},
'linkage-to-hiv-care' => {
  'lower_95ci_weight_percent'  => 'Lower_95CI_Percent',
  'upper_95ci_weight_percent'  => 'Upper_95CI_Percent'
},
'low-birthweight' => {
  'lower_95ci_weight_percent'  => 'Lower_95CI_Percent',
  'upper_95ci_weight_percent'  => 'Upper_95CI_Percent'
},
'lung-cancer-deaths' => {
  'lower_95ci_weight_percent'  => 'Lower_95CI_Age_Adj_Rate',
  'upper_95ci_weight_percent'  => 'Upper_95CI_Age_Adj_Rate'
},
'lung-cancer-incidence' => {
  'lower_95ci_weight_percent'  => 'Lower_95CI_Age_Adj_Rate',
  'upper_95ci_weight_percent'  => 'Upper_95CI_Age_Adj_Rate'
},
'motor-vehicle-crash-deaths' => {
  'lower_95ci_weight_percent'  => 'Lower_95CI_Age_Adj_Rate',
  'upper_95ci_weight_percent'  => 'Upper_95CI_Age_Adj_Rate'
},
'nephritis-nephrotic-syndrome-and-nephrosis-deaths' => {
  'lower_95ci_weight_percent'  => 'Lower_95CI_Age_Adj_Rate',
  'upper_95ci_weight_percent'  => 'Upper_95CI_Age_Adj_Rate'
},
'opioid-related-overdose-deaths' => {
  'lower_95ci_weight_percent'  => 'Lower_95CI_Age_Adj_Rate',
  'upper_95ci_weight_percent'  => 'Upper_95CI_Age_Adj_Rate'
},
'prenatal-care-in-first-trimester' => {
  'lower_95ci_weight_percent'  => 'Lower_95CI_Percent',
  'upper_95ci_weight_percent'  => 'Upper_95CI_Percent'
},
'primary-care-provider' => {
  'lower_95ci_weight_percent'  => 'Lower_95CI_Weight_Percent',
  'upper_95ci_weight_percent'  => 'Upper_95CI_Weight_Percent'
},
'prostate-cancer-incidence' => {
  'lower_95ci_weight_percent'  => 'Lower_95CI_Age_Adj_Rate',
  'upper_95ci_weight_percent'  => 'Upper_95CI_Age_Adj_Rate'
},
'routine-checkup' => {
  'lower_95ci_weight_percent'  => 'Lower_95CI_Weight_Percent',
  'upper_95ci_weight_percent'  => 'Upper_95CI_Weight_Percent'
},
'smoking-during-pregnancy' => {
  'lower_95ci_weight_percent'  => 'Lower_95CI_Percent',
  'upper_95ci_weight_percent'  => 'Upper_95CI_Percent'
},
'stroke-deaths' => {
  'lower_95ci_weight_percent'  => 'Lower_95CI_Age_Adj_Rate',
  'upper_95ci_weight_percent'  => 'Upper_95CI_Age_Adj_Rate'
},
'suicide' => {
  'lower_95ci_weight_percent'  => 'Lower_95CI_Age_Adj_Rate',
  'upper_95ci_weight_percent'  => 'Upper_95CI_Age_Adj_Rate'
},
'syphilis' => {
  'lower_95ci_weight_percent'  => 'Lower_95CI_Crude_Rate',
  'upper_95ci_weight_percent'  => 'Upper_95CI_Crude_Rate'
},
'teen-birth-rate' => {
  'lower_95ci_weight_percent'  => 'Lower_95CI_Crude_Rate',
  'upper_95ci_weight_percent'  => 'Upper_95CI_Crude_Rate'
},
'tobacco-related-deaths' => {
  'lower_95ci_weight_percent'  => 'Lower_95CI_Age_Adj_Rate',
  'upper_95ci_weight_percent'  => 'Upper_95CI_Age_Adj_Rate'
},
'total-fertility-rate' => {
  'lower_95ci_weight_percent'  => 'Lower_95CI_Age_Adj_Rate',
  'upper_95ci_weight_percent'  => 'Upper_95CI_Age_Adj_Rate'
},
'tuberculosis' => {
  'lower_95ci_weight_percent'  => 'Lower_95CI_Crude_Rate',
  'upper_95ci_weight_percent'  => 'Upper_95CI_Crude_Rate'
},
'twin-birth-rate' => {
  'lower_95ci_weight_percent'  => 'Lower_95CI_Crude_Rate',
  'upper_95ci_weight_percent'  => 'Upper_95CI_Crude_Rate'
},
'varicella' => {
  'lower_95ci_weight_percent'  => 'Lower_95CI_Crude_Rate',
  'upper_95ci_weight_percent'  => 'Upper_95CI_Crude_Rate'
},
'violent-crime' => {
  'lower_95ci_weight_percent'  => 'Lower_95CI_Crude_Rate',
  'upper_95ci_weight_percent'  => 'Upper_95CI_Crude_Rate'
},
'years-of-potential-life-lost-ypll' => {
  'lower_95ci_weight_percent'  => 'Lower_95CI_Crude_Rate',
  'upper_95ci_weight_percent'  => 'Upper_95CI_Crude_Rate'
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
