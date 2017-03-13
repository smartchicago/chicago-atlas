class CommunityAreaDetailSerializer < ActiveModel::Serializer
  attributes :id, :name, :slug, :sub_categories

  def sub_categories
    object.sub_categories.map do |sub_category|
      CommunityAreaSubCategorySerializer.new(sub_category, scope: scope, root: false, geo_slug: @instance_options[:geo_slug]) 
    end
  end
end
