class ResourceSerializer < ActiveModel::Serializer
  attributes :id, :uploader_id, :category_group_id, :indicator_id, :year, :geo_group_id, :demo_group_id, :number, :cum_number, :ave_annual_number, :crude_rate, :lower_95ci_crude_rate, :upper_95ci_crude_rate, :percent, :lower_95ci_percent, :upper_95ci_percent, :weight_number, :weight_percent, :lower_95ci_weight_percent, :upper_95ci_weight_percent,:map_key, :flag

  belongs_to :uploader
  belongs_to :category_group
  belongs_to :demo_group
  belongs_to :geo_group
  belongs_to :indicator

end
