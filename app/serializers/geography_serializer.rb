class GeographySerializer < ActiveModel::Serializer
  # attributes :id, :geo_type, :name, :slug, :geometry, :centroid, :adjacent_zips, :adjacent_community_areas
  attributes :id, :name, :slug
  has_many :statistics
end
