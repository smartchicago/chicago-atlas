class Geography
  include MongoMapper::Document

  key :type, String
  key :name, String
  key :external_id, Integer
  key :slug, String
  key :geometry, Array
  many :statistics
  timestamps!
    
end
