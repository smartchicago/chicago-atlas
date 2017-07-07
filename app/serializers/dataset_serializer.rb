class DatasetSerializer < ActiveModel::Serializer
  attributes :id, :description, :metadata, :name, :slug, :provider, :url, :category_id, :data_type, :stat_type
end
