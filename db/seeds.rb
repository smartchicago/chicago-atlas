
#  Upload Admin
user          =  User.new
user.email    = 'admin@chicagohealthatlas.com'
user.password = '1234567890'
user.name     = 'admin'
user.save!



#  Upload Geography
chicago = Geography.new(
  :geo_type => "City",
  :name => 'Chicago',
  :slug => 'chicago',
  :geometry => ''
)
chicago.id = 100
chicago.save!
