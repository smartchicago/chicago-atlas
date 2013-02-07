class Statistic
  include MongoMapper::EmbeddedDocument

  key :type, String
  key :year, Integer
  key :value, Float
  key :lower_ci, Float
  key :upper_ci, Float

end
