# spec/factories/resource.rb

FactoryGirl.define do
  factory :resource do
    uploader
    category
    demo_group
    geo_group
    indicator
    year { 2017 }
    number { 0 }
    cum_number { 0 }
    ave_annual_number { 0.0 }
    crude_rate { 0.0 }
    lower_95ci_crude_rate { 0.0 }
    upper_95ci_crude_rate { 0.0 }
    age_adj_rate { 0.0 }
    lower_95ci_adj_rate { 0.0 }
    upper_95ci_adj_rate { 0.0 }
    percent { 0.0 }
    lower_95ci_percent { 0.0 }
    upper_95ci_percent { 0.0 }
    weight_number { 0.0 }
    weight_percent { 0.0 }
    lower_95ci_weight_percent { 0.0 }
    upper_95ci_weight_percent { 0.0 }
    map_key { "S" }
    flag { "S" }
  end
end
