class TopicCitySerializer < ActiveModel::Serializer
  cache key: 'TopicCity', expires_in: 3.hours
  attributes :id, :uploader_path, :indicator, :demo_group_name,
             :demography, :number, :cum_number, :ave_annual_number,
             :crude_rate, :lower_95ci_crude_rate, :upper_95ci_crude_rate,
             :percent, :lower_95ci_weight_percent, :upper_95ci_weight_percent,
             :weight_number, :weight_percent, :value_type, :flag, :hide_rate_column_summary

  SOURCE_CHANGE_LIST = {
    'accidents' => {
      'weight_number'  => 'number',
      'weight_percent' => 'age_adj_rate'
    },
    'active-transportation' => {
      'weight_number'  => 'number',
      'weight_percent' => 'percent'
    },
    'adult-binge-drinking' => {
      'weight_number'  => 'weight_number',
      'weight_percent' => 'weight_percent'
    },
    'adult-e-cigarette-use' => {
      'weight_number'  => 'weight_number',
      'weight_percent' => 'weight_percent'
    },
    'adult-flu-vaccine' => {
      'weight_number'  => 'weight_number',
      'weight_percent' => 'weight_percent'
    },
    'adult-fruit-and-vegetable-servings' => {
      'weight_number'  => 'weight_number',
      'weight_percent' => 'weight_percent'
    },
    'adult-obesity' => {
      'weight_number'  => 'weight_number',
      'weight_percent' => 'weight_percent'
    },
    'adult-physical-inactivity' => {
      'weight_number'  => 'weight_number',
      'weight_percent' => 'weight_percent'
    },
    'adult-smoking' => {
      'weight_number'  => 'weight_number',
      'weight_percent' => 'weight_percent'
    },
    'adult-soda-consumption' => {
      'weight_number'  => 'weight_number',
      'weight_percent' => 'weight_percent'
    },
    'alcohol-induced-deaths' => {
      'weight_number'  => 'number',
      'weight_percent' => 'age_adj_rate'
    },
    'alcohol-related-hospitalizations' => {
      'weight_number'  => 'number',
      'weight_percent' => 'age_adj_rate'
    },
    'alzheimers-disease' => {
      'weight_number'  => 'number',
      'weight_percent' => 'age_adj_rate'
    },
    'annual-dental-cleaning' => {
      'weight_number'  => 'weight_number',
      'weight_percent' => 'weight_percent'
    },
    'asthma' => {
      'weight_number'  => 'weight_number',
      'weight_percent' => 'weight_percent'
    },
    'asthma-ed-visits-(0-4-years)' => {
      'weight_number'  => 'number',
      'weight_percent' => 'crude_rate'
    },
    'asthma-ed-visits-(0-18-years)' => {
      'weight_number'  => 'number',
      'weight_percent' => 'age_adj_rate'
    },
    'asthma-ed-visits-(65+-years)' => {
      'weight_number'  => 'number',
      'weight_percent' => 'age_adj_rate'
    },
    'avoidable-ed-visits' => {
      'weight_number'  => 'number',
      'weight_percent' => 'age_adj_rate'
    },
    'behavioral-health-hospitalizations' => {
      'weight_number'  => 'number',
      'weight_percent' => 'age_adj_rate'
    },
    'behavioral-health-treatment' => {
      'weight_number'  => 'weight_number',
      'weight_percent' => 'weight_percent'
    },
    'breast-cancer-screening' => {
      'weight_number'  => 'weight_number',
      'weight_percent' => 'weight_percent'
    },
    'bullying' => {
      'weight_number'  => 'weight_number',
      'weight_percent' => 'weight_percent'
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
      'weight_number'  => 'ave_annual_number',
      'weight_percent' => 'age_adj_rate'
    },
    'cervical-cancer-incidence' => {
      'weight_number'  => 'ave_annual_number',
      'weight_percent' => 'age_adj_rate'
    },
    'cervical-cancer-screening' => {
      'weight_number'  => 'weight_number',
      'weight_percent' => 'weight_percent'
    },
    'cesarean-delivery' => {
      'weight_number'  => 'number',
      'weight_percent' => 'percent'
    },
    'child-obesity' => {
      'weight_number'  => 'weight_number',
      'weight_percent' => 'weight_percent'
    },
    'child-poverty' => {
      'weight_number'  => 'number',
      'weight_percent' => 'percent'
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
    'college-graduation-or-more' => {
      'weight_number'  => 'number',
      'weight_percent' => 'percent'
    },
    'colorectal-cancer-deaths' => {
      'weight_number'  => 'number',
      'weight_percent' => 'age_adj_rate'
    },
    'colorectal-cancer-incidence' => {
      'weight_number'  => 'ave_annual_number',
      'weight_percent' => 'age_adj_rate'
    },
    'colorectal-cancer-screening' => {
      'weight_number'  => 'weight_number',
      'weight_percent' => 'weight_percent'
    },
    'coronary-heart-disease-deaths' => {
      'weight_number'  => 'number',
      'weight_percent' => 'age_adj_rate'
    },
    'crowded-housing' => {
      'weight_number'  => 'number',
      'weight_percent' => 'percent'
    },
    'crude-birth-rate' => {
      'weight_number'  => 'number',
      'weight_percent' => 'crude_rate'
    },
    'dental-care-emergencies' => {
      'weight_number'  => 'number',
      'weight_percent' => 'age_adj_rate',
      'hide_rate_column_summary' => true
    },
    'diabetes' => {
      'weight_number'  => 'weight_number',
      'weight_percent' => 'weight_percent'
    },
    'diabetes-deaths' => {
      'weight_number'  => 'number',
      'weight_percent' => 'age_adj_rate'
    },
    'diabetes-related-deaths' => {
      'weight_number'  => 'number',
      'weight_percent' => 'age_adj_rate'
    },
    'diabetes-related-hospitalizations' => {
      'weight_number'  => 'number',
      'weight_percent' => 'age_adj_rate'
    },
    'diabetes-related-lower-extremity-amputation-hospitalizations' => {
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
    'drug-related-hospitalizations' => {
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
    'female-population' => {
      'weight_number'  => 'number',
      'weight_percent' => 'percent'
    },
    'firearm-related-homicides' => {
      'weight_number'  => 'number',
      'weight_percent' => 'age_adj_rate'
    },
    'firearm-related-homicides-by-injury-location' => {
      'weight_number'  => 'number',
      'weight_percent' => 'crude_rate'
    },
    'food-access' => {
      'weight_number'  => 'number',
      'weight_percent' => 'percent'
    },
    'food-stamps-snap' => {
      'weight_number'  => 'number',
      'weight_percent' => 'percent'
    },
    'foreign-born' => {
      'weight_number'  => 'number',
      'weight_percent' => 'percent'
    },
    'general-fertility-rate' => {
      'weight_number'  => 'number',
      'weight_percent' => 'crude_rate'
    },
    'gonorrhea' => {
      'weight_number'  => 'number',
      'weight_percent' => 'crude_rate'
    },
    'have-a-disability' => {
      'weight_number'  => 'number',
      'weight_percent' => 'percent'
    },
    'health-care-satisfaction' => {
      'weight_number'  => 'weight_number',
      'weight_percent' => 'weight_percent'
    },
    'heart-disease-deaths' => {
      'weight_number'  => 'number',
      'weight_percent' => 'age_adj_rate'
    },
    'high-school-graduation' => {
      'weight_number'  => 'number',
      'weight_percent' => 'percent'
    },
    'hispanic-or-latino' => {
      'weight_number'  => 'number',
      'weight_percent' => 'percent'
    },
    'hiv-incidence' => {
      'weight_number'  => 'number',
      'weight_percent' => 'crude_rate'
    },
    'hiv-prevalence' => {
      'weight_number'  => 'number',
      'weight_percent' => 'crude_rate'
    },
    'hiv-viral-suppression' => {
      'weight_number'  => 'number',
      'weight_percent' => 'percent'
    },
    'homicides' => {
      'weight_number'  => 'number',
      'weight_percent' => 'age_adj_rate'
    },
    'household-poverty' => {
      'weight_number'  => 'number',
      'weight_percent' => 'percent'
    },
    'hypertension' => {
      'weight_number'  => 'weight_number',
      'weight_percent' => 'weight_percent'
    },
    'individual-poverty' => {
      'weight_number'  => 'number',
      'weight_percent' => 'percent'
    },
    'infant-mortality' => {
      'weight_number'  => 'number',
      'weight_percent' => 'crude_rate'
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
      'weight_number'  => 'ave_annual_number',
      'weight_percent' => 'age_adj_rate'
    },
    'lead-poisoning' => {
      'weight_number'  => 'number',
      'weight_percent' => 'crude_rate'
    },
    'limited-english-proficiency' => {
      'weight_number'  => 'number',
      'weight_percent' => 'percent'
    },
    'linkage-to-hiv-care' => {
      'weight_number'  => 'number',
      'weight_percent' => 'percent'
    },
    'low-birthweight' => {
      'weight_number'  => 'number',
      'weight_percent' => 'percent'
    },
    'lung-cancer-deaths' => {
      'weight_number'  => 'number',
      'weight_percent' => 'age_adj_rate'
    },
    'lung-cancer-incidence' => {
      'weight_number'  => 'ave_annual_number',
      'weight_percent' => 'age_adj_rate'
    },
    'male-population' => {
      'weight_number'  => 'number',
      'weight_percent' => 'percent'
    },
    'mood-and-depressive-disorder-hospitalizations' => {
      'weight_number'  => 'number',
      'weight_percent' => 'age_adj_rate'
    },
    'motor-vehicle-crash-deaths' => {
      'weight_number'  => 'number',
      'weight_percent' => 'age_adj_rate'
    },
    'neighborhood-safety' => {
      'weight_number'  => 'weight_number',
      'weight_percent' => 'weight_percent'
    },
    'nephritis-nephrotic-syndrome-and-nephrosis-deaths' => {
      'weight_number'  => 'number',
      'weight_percent' => 'age_adj_rate'
    },
    'no-health-insurance' => {
      'weight_number'  => 'number',
      'weight_percent' => 'percent'
    },
    'no-high-school-graduation' => {
      'weight_number'  => 'number',
      'weight_percent' => 'percent'
    },
    'non-hispanic-african-american-or-black' => {
      'weight_number'  => 'number',
      'weight_percent' => 'percent'
    },
    'non-hispanic-asian-or-pacific-islander' => {
      'weight_number'  => 'number',
      'weight_percent' => 'percent'
    },
    'non-hispanic-white' => {
      'weight_number'  => 'number',
      'weight_percent' => 'percent'
    },
    'opioid-related-overdose-deaths' => {
      'weight_number'  => 'number',
      'weight_percent' => 'age_adj_rate'
    },
    'opioid-overdose' => {
      'weight_number'  => 'number',
      'weight_percent' => 'age_adj_rate'
    },
    'overall-health-status' => {
      'weight_number'  => 'weight_number',
      'weight_percent' => 'weight_percent'
    },
    'pertussis' => {
      'weight_number'  => 'number',
      'weight_percent' => 'crude_rate'
    },
    'prenatal-care-in-first-trimester' => {
      'weight_number'  => 'number',
      'weight_percent' => 'percent'
    },
    'prescription-opiate-misuse' => {
      'weight_number'  => 'weight_number',
      'weight_percent' => 'weight_percent'
    },
    'preterm-births' => {
      'weight_number'  => 'number',
      'weight_percent' => 'percent'
    },
    'preventable-hospitalizations' => {
      'weight_number'  => 'number',
      'weight_percent' => 'age_adj_rate'
    },
    'primary-care-provider' => {
      'weight_number'  => 'weight_number',
      'weight_percent' => 'weight_percent'
    },
    'prostate-cancer-deaths' => {
      'weight_number'  => 'number',
      'weight_percent' => 'age_adj_rate'
    },
    'prostate-cancer-incidence' => {
      'weight_number'  => 'ave_annual_number',
      'weight_percent' => 'age_adj_rate'
    },
    'received-needed-care' => {
      'weight_number'  => 'weight_number',
      'weight_percent' => 'weight_percent'
    },
    'routine-checkup' => {
      'weight_number'  => 'weight_number',
      'weight_percent' => 'weight_percent'
    },
    'schizophrenic-disorder-hospitalizations' => {
      'weight_number'  => 'number',
      'weight_percent' => 'age_adj_rate'
    },
    'school-fights' => {
      'weight_number'  => 'weight_number',
      'weight_percent' => 'weight_percent'
    },
    'school-safety' => {
      'weight_number'  => 'weight_number',
      'weight_percent' => 'weight_percent'
    },
    'serious-psychological-distress' => {
      'weight_number'  => 'weight_number',
      'weight_percent' => 'weight_percent'
    },
    'severe-housing-cost-burden' => {
      'weight_number'  => 'number',
      'weight_percent' => 'percent'
    },
    'single-parent-households' => {
      'weight_number'  => 'number',
      'weight_percent' => 'percent'
    },
    'smoking-during-pregnancy' => {
      'weight_number'  => 'number',
      'weight_percent' => 'percent'
    },
    'stroke-deaths' => {
      'weight_number'  => 'number',
      'weight_percent' => 'age_adj_rate'
    },
    'suicide' => {
      'weight_number'  => 'number',
      'weight_percent' => 'age_adj_rate'
    },
    'suspensions' => {
      'weight_number'  => 'number',
      'weight_percent' => 'percent'
    },
    'syphilis' => {
      'weight_number'  => 'number',
      'weight_percent' => 'crude_rate'
    },
    'teen-birth-rate' => {
      'weight_number'  => 'number',
      'weight_percent' => 'crude_rate'
    },
    'tobacco-related-deaths' => {
      'weight_number'  => 'number',
      'weight_percent' => 'age_adj_rate'
    },
    'total-fertility-rate' => {
      'weight_number'  => 'number',
      'weight_percent' => 'age_adj_rate'
    },
    'total-population' => {
      'weight_number'  => 'number',
      'weight_percent' => 'percent'
    },
    'traffic-crash-fatalities' => {
      'weight_number'  => 'ave_annual_number',
      'weight_percent' => 'age_adj_rate'
    },
    'tuberculosis' => {
      'weight_number'  => 'number',
      'weight_percent' => 'crude_rate'
    },
    'twin-birth-rate' => {
      'weight_number'  => 'number',
      'weight_percent' => 'crude_rate'
    },
    'unemployment' => {
      'weight_number'  => 'number',
      'weight_percent' => 'percent'
    },
    'vacant-housing' => {
      'weight_number'  => 'number',
      'weight_percent' => 'percent'
    },
    'varicella' => {
      'weight_number'  => 'number',
      'weight_percent' => 'crude_rate'
    },
    'very-low-birthweight' => {
      'weight_number'  => 'number',
      'weight_percent' => 'percent'
    },
    'violent-crime' => {
      'weight_number'  => 'number',
      'weight_percent' => 'crude_rate'
    },
    'years-of-potential-life-lost' => {
      'weight_number'  => 'number',
      'weight_percent' => 'crude_rate'
    },
    'youth-binge-drinking' => {
      'weight_number'  => 'weight_number',
      'weight_percent' => 'weight_percent'
    },
    'youth-condom-use' => {
      'weight_number'  => 'weight_number',
      'weight_percent' => 'weight_percent'
    },
    'youth-depression' => {
      'weight_number'  => 'weight_number',
      'weight_percent' => 'weight_percent'
    },
    'youth-fruit-and-vegetable-servings' => {
      'weight_number'  => 'weight_number',
      'weight_percent' => 'weight_percent'
    },
    'youth-physical-activity' => {
      'weight_number'  => 'weight_number',
      'weight_percent' => 'weight_percent'
    },
    'youth-smoking' => {
      'weight_number'  => 'weight_number',
      'weight_percent' => 'weight_percent'
    },
    'youth-soda-consumption' => {
      'weight_number'  => 'weight_number',
      'weight_percent' => 'weight_percent'
    },
    'youth-suicide-attempts' => {
      'weight_number'  => 'weight_number',
      'weight_percent' => 'weight_percent'
    },
    'early-childhood-education' => {
      'weight_number'  => 'weight_number',
      'weight_percent' => 'percent'
    },
    'early-intervention-services' => {
      'weight_number'  => 'weight_number',
      'weight_percent' => 'percent'
    },
    'grandparents-raising-grandchildren' => {
      'weight_number'  => 'number',
      'weight_percent' => 'number',
      'hide_rate_column_summary' => true
    },
    'income-diversity' => {
      'weight_number'  => 'weight_number',
      'weight_percent' => 'percent'
    },
    'life-expectancy' => {
      'weight_number'  => 'number',
      'weight_percent' => 'number',
      'hide_rate_column_summary' => true
    },
    'mean-age-at-first-birth' => {
      'weight_number'  => 'number',
      'weight_percent' => 'number',
      'hide_rate_column_summary' => true
    },
    'median-household-income' => {
      'weight_number'  => 'number',
      'weight_percent' => 'number',
      'hide_rate_column_summary' => true
    },
    'non-fatal-shootings' => {
      'weight_number'  => 'number',
      'weight_percent' => 'number',
      'hide_rate_column_summary' => true
    },
    'per-capita-income' => {
      'weight_number'  => 'number',
      'weight_percent' => 'number',
      'hide_rate_column_summary' => true
    },
    'permanent-supportive-housing' => {
      'weight_number'  => 'number',
      'weight_percent' => 'number',
      'hide_rate_column_summary' => true
    },
    'school-attendance' => {
      'weight_number'  => 'weight_number',
      'weight_percent' => 'percent'
    },
    'school-based-health-services---dental' => {
      'weight_number'  => 'number',
      'weight_percent' => 'number',
      'hide_rate_column_summary' => true
    },
    'school-based-health-services-sti-screening' => {
      'weight_number'  => 'number',
      'weight_percent' => 'number',
      'hide_rate_column_summary' => true
    },
    'school-based-health-services-vision' => {
      'weight_number'  => 'number',
      'weight_percent' => 'number',
      'hide_rate_column_summary' => true
    },
    'seniors-living-alone' => {
      'weight_number'  => 'number',
      'weight_percent' => 'number',
      'hide_rate_column_summary' => true
    },
    'serious-traffic-crash-injuries' => {
      'weight_number'  => 'number',
      'weight_percent' => 'number',
      'hide_rate_column_summary' => true
    },
    'sexual-assault' => {
      'weight_number'  => 'number',
      'weight_percent' => 'weight_percent'
    },
    'violent-crime-in-public-spaces' => {
      'weight_number'  => 'number',
      'weight_percent' => 'number',
      'hide_rate_column_summary' => true
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
    'asthma-ed-visits-(0-18-years)' => {
      'lower_95ci_weight_percent'  => 'lower_95ci_adj_rate',
      'upper_95ci_weight_percent'  => 'upper_95ci_adj_rate'
    },
    'asthma-ed-visits-(65+-years)' => {
      'lower_95ci_weight_percent'  => 'lower_95ci_adj_rate',
      'upper_95ci_weight_percent'  => 'upper_95ci_adj_rate'
    },
    'traffic-crash-fatalities' => {
      'lower_95ci_weight_percent'  => 'lower_95ci_adj_rate',
      'upper_95ci_weight_percent'  => 'upper_95ci_adj_rate'
    },
    'schizophrenic-disorder-hospitalizations' => {
      'lower_95ci_weight_percent'  => 'lower_95ci_adj_rate',
      'upper_95ci_weight_percent'  => 'upper_95ci_adj_rate'
    },
    'prostate-cancer-deaths' => {
      'lower_95ci_weight_percent'  => 'lower_95ci_adj_rate',
      'upper_95ci_weight_percent'  => 'upper_95ci_adj_rate'
    },
    'preventable-hospitalizations' => {
      'lower_95ci_weight_percent'  => 'lower_95ci_adj_rate',
      'upper_95ci_weight_percent'  => 'upper_95ci_adj_rate'
    },
    'mood-and-depressive-disorder-hospitalizations' => {
      'lower_95ci_weight_percent'  => 'lower_95ci_adj_rate',
      'upper_95ci_weight_percent'  => 'upper_95ci_adj_rate'
    },
    'influenza-and-pneumonia-deaths' => {
      'lower_95ci_weight_percent'  => 'lower_95ci_adj_rate',
      'upper_95ci_weight_percent'  => 'upper_95ci_adj_rate'
    },
    'diabetes-related-hospitalizations' => {
      'lower_95ci_weight_percent'  => 'lower_95ci_adj_rate',
      'upper_95ci_weight_percent'  => 'upper_95ci_adj_rate'
    },
    'diabetes-related-lower-extremity-amputation-hospitalizations' => {
      'lower_95ci_weight_percent'  => 'lower_95ci_adj_rate',
      'upper_95ci_weight_percent'  => 'upper_95ci_adj_rate'
    },
    'dental-care-emergencies' => {
      'lower_95ci_weight_percent'  => 'lower_95ci_adj_rate',
      'upper_95ci_weight_percent'  => 'upper_95ci_adj_rate'
    },
    'behavioral-health-hospitalizations' => {
      'lower_95ci_weight_percent'  => 'lower_95ci_adj_rate',
      'upper_95ci_weight_percent'  => 'upper_95ci_adj_rate'
    },
    'avoidable-ed-visits' => {
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
    'preterm-births' => {
      'lower_95ci_weight_percent'  => 'lower_95ci_percent',
      'upper_95ci_weight_percent'  => 'upper_95ci_percent'
    },
    'hiv-viral-suppression' => {
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
    'pertussis' => {
      'lower_95ci_weight_percent'  => 'lower_95ci_crude_rate',
      'upper_95ci_weight_percent'  => 'upper_95ci_crude_rate'
    },
    'hiv-prevalence' => {
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
    'drug-related-hospitalizations' => {
      'lower_95ci_weight_percent'  => 'lower_95ci_adj_rate',
      'upper_95ci_weight_percent'  => 'upper_95ci_adj_rate'
    },
    'alcohol-related-hospitalizations' => {
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
      'lower_95ci_weight_percent'  => 'lower_95ci_adj_rate',
      'upper_95ci_weight_percent'  => 'upper_95ci_adj_rate'
    },
    'infant-mortality' => {
      'lower_95ci_weight_percent'  => 'lower_95ci_crude_rate',
      'upper_95ci_weight_percent'  => 'upper_95ci_crude_rate'
    },
    'influenza-pneumonia-deaths' => {
      'lower_95ci_weight_percent'  => 'lower_95ci_adj_rate',
      'upper_95ci_weight_percent'  => 'upper_95ci_adj_rate'
    },
    'injury-deaths' => {
      'lower_95ci_weight_percent'  => 'lower_95ci_adj_rate',
      'upper_95ci_weight_percent'  => 'upper_95ci_adj_rate'
    },
    'late-stage-female-breast-cancer-incidence' => {
      'lower_95ci_weight_percent'  => 'lower_95ci_adj_rate',
      'upper_95ci_weight_percent'  => 'upper_95ci_adj_rate'
    },
    'lead-poisoning' => {
      'lower_95ci_weight_percent'  => 'lower_95ci_crude_rate',
      'upper_95ci_weight_percent'  => 'upper_95ci_crude_rate'
    },
    'linkage-to-hiv-care' => {
      'lower_95ci_weight_percent'  => 'lower_95ci_percent',
      'upper_95ci_weight_percent'  => 'upper_95ci_percent'
    },
    'low-birthweight' => {
      'lower_95ci_weight_percent'  => 'lower_95ci_percent',
      'upper_95ci_weight_percent'  => 'upper_95ci_percent'
    },
    'lung-cancer-deaths' => {
      'lower_95ci_weight_percent'  => 'lower_95ci_adj_rate',
      'upper_95ci_weight_percent'  => 'upper_95ci_adj_rate'
    },
    'lung-cancer-incidence' => {
      'lower_95ci_weight_percent'  => 'lower_95ci_adj_rate',
      'upper_95ci_weight_percent'  => 'upper_95ci_adj_rate'
    },
    'motor-vehicle-crash-deaths' => {
      'lower_95ci_weight_percent'  => 'lower_95ci_adj_rate',
      'upper_95ci_weight_percent'  => 'upper_95ci_adj_rate'
    },
    'nephritis-nephrotic-syndrome-and-nephrosis-deaths' => {
      'lower_95ci_weight_percent'  => 'lower_95ci_adj_rate',
      'upper_95ci_weight_percent'  => 'upper_95ci_adj_rate'
    },
    'opioid-related-overdose-deaths' => {
      'lower_95ci_weight_percent'  => 'lower_95ci_adj_rate',
      'upper_95ci_weight_percent'  => 'upper_95ci_adj_rate'
    },
    'opioid-overdose' => {
      'lower_95ci_weight_percent'  => 'lower_95ci_adj_rate',
      'upper_95ci_weight_percent'  => 'upper_95ci_adj_rate'
    },
    'prenatal-care-in-first-trimester' => {
      'lower_95ci_weight_percent'  => 'lower_95ci_percent',
      'upper_95ci_weight_percent'  => 'upper_95ci_percent'
    },
    'very-low-birthweight' => {
      'lower_95ci_weight_percent'  => 'lower_95ci_percent',
      'upper_95ci_weight_percent'  => 'upper_95ci_percent'
    },
    'primary-care-provider' => {
      'lower_95ci_weight_percent'  => 'lower_95ci_weight_percent',
      'upper_95ci_weight_percent'  => 'upper_95ci_weight_percent'
    },
    'prostate-cancer-incidence' => {
      'lower_95ci_weight_percent'  => 'lower_95ci_adj_rate',
      'upper_95ci_weight_percent'  => 'upper_95ci_adj_rate'
    },
    'routine-checkup' => {
      'lower_95ci_weight_percent'  => 'lower_95ci_weight_percent',
      'upper_95ci_weight_percent'  => 'upper_95ci_weight_percent'
    },
    'smoking-during-pregnancy' => {
      'lower_95ci_weight_percent'  => 'lower_95ci_percent',
      'upper_95ci_weight_percent'  => 'upper_95ci_percent'
    },
    'stroke-deaths' => {
      'lower_95ci_weight_percent'  => 'lower_95ci_adj_rate',
      'upper_95ci_weight_percent'  => 'upper_95ci_adj_rate'
    },
    'suicide' => {
      'lower_95ci_weight_percent'  => 'lower_95ci_adj_rate',
      'upper_95ci_weight_percent'  => 'upper_95ci_adj_rate'
    },
    'syphilis' => {
      'lower_95ci_weight_percent'  => 'lower_95ci_crude_rate',
      'upper_95ci_weight_percent'  => 'upper_95ci_crude_rate'
    },
    'teen-birth-rate' => {
      'lower_95ci_weight_percent'  => 'lower_95ci_crude_rate',
      'upper_95ci_weight_percent'  => 'upper_95ci_crude_rate'
    },
    'tobacco-related-deaths' => {
      'lower_95ci_weight_percent'  => 'lower_95ci_adj_rate',
      'upper_95ci_weight_percent'  => 'upper_95ci_adj_rate'
    },
    'total-fertility-rate' => {
      'lower_95ci_weight_percent'  => 'lower_95ci_adj_rate',
      'upper_95ci_weight_percent'  => 'upper_95ci_adj_rate'
    },
    'tuberculosis' => {
      'lower_95ci_weight_percent'  => 'lower_95ci_crude_rate',
      'upper_95ci_weight_percent'  => 'upper_95ci_crude_rate'
    },
    'twin-birth-rate' => {
      'lower_95ci_weight_percent'  => 'lower_95ci_crude_rate',
      'upper_95ci_weight_percent'  => 'upper_95ci_crude_rate'
    },
    'varicella' => {
      'lower_95ci_weight_percent'  => 'lower_95ci_crude_rate',
      'upper_95ci_weight_percent'  => 'upper_95ci_crude_rate'
    },
    'violent-crime' => {
      'lower_95ci_weight_percent'  => 'lower_95ci_crude_rate',
      'upper_95ci_weight_percent'  => 'upper_95ci_crude_rate'
    },
    'years-of-potential-life-lost' => {
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

  def upper_95ci_weight_percent
    CI_CHANGE_LIST[object.indicator.slug].present? ? object[CI_CHANGE_LIST[object.indicator.slug]['upper_95ci_weight_percent']] : object.upper_95ci_weight_percent
  end

  def lower_95ci_weight_percent
    CI_CHANGE_LIST[object.indicator.slug].present? ? object[CI_CHANGE_LIST[object.indicator.slug]['lower_95ci_weight_percent']] : object.lower_95ci_weight_percent
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

  def crude_rate
    object['crude_rate'].present? ? object['crude_rate'] : object['age_adj_rate']
  end

  def value_type
    percent_text = 'percent'
    rate_text = 'rate'
    unless SOURCE_CHANGE_LIST[object.indicator.slug].present?
      return percent_text
    else
      attr_value = SOURCE_CHANGE_LIST[object.indicator.slug]['weight_percent']
      return ['percent', 'weight_percent'].include?(attr_value) ? percent_text : rate_text
    end
  end

  def hide_rate_column_summary
    if SOURCE_CHANGE_LIST[object.indicator.slug].present?
      SOURCE_CHANGE_LIST[object.indicator.slug]['hide_rate_column_summary'] || false
    else
      false
    end
  end
end
