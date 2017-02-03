
#  Upload Admin
user          =  User.new
user.email    = 'niels@parrolabs.com'
user.password = '1234567890'
user.name     = 'admin'
user.save!

user          =  User.new
user.email    = 'tommy@parrolabs.com'
user.password = '1234567890'
user.name     = 'admin'
user.save!

user          =  User.new
user.email    = 'german@parrolabs.com'
user.password = '1234567890'
user.name     = 'admin'
user.save!

user          =  User.new
user.email    = 'teo@parrolabs.com'
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
