class HospitalSerializer < ActiveModel::Serializer
  attributes :src_id, :name, :slug, :primary_type, :sub_type, :addr_street, :addr_city, :addr_zip, :ownership_type, :contact_email, :contact_phone, :lat_long, :description, :phone, :url, :report_url, :report_name, :geometry, :areas, :area_type, :area_alt, :chna_url, :twitter, :facebook, :doc_embed_url
end
