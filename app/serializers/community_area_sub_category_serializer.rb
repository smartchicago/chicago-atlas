class CommunityAreaSubCategorySerializer < ActiveModel::Serializer
  attributes :id, :name, :slug, :indicators
  def indicators
    object.indicators.map do |indicator|
      CommunityAreaIndicatorSerializer.new(indicator, scope: scope, root: false, geo_ids: @instance_options[:geo_ids])
    end
  end
end
