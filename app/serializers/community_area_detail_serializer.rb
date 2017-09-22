class CommunityAreaDetailSerializer < ActiveModel::Serializer
  attributes :id, :name, :slug, :sub_categories

  def sub_categories
    object.sub_categories.exclude_indices.map do |sub_category|
      CommunityAreaSubCategorySerializer.new(sub_category, scope: scope, root: false, geo_ids: @instance_options[:geo_ids])
    end
  end
end
