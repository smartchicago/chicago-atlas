class ResourceSerializer < ActiveModel::Serializer
  attributes :id, :uploader, :category_group, :sub_category, :indicator, :year_from, :year_to, :geo_group, :demo_group, :number, :cum_number, :ave_annual_number, :crude_rate, :lower_95ci_crude_rate, :upper_95ci_crude_rate, :percent, :lower_95ci_percent, :upper_95ci_percent, :weight_number, :weight_percent, :lower_95ci_weight_percent, :upper_95ci_weight_percent,:map_key, :flag

  belongs_to :uploader
  belongs_to :category_group
  belongs_to :sub_category
  belongs_to :demo_group
  belongs_to :geo_group
  belongs_to :indicator

end
