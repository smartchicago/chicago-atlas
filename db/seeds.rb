# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

categories = Category.create([
  { name: 'Births', description: "Information from the City of Chicago relating to number of births, fertility rates, teen births, and other birth-related data by community area for the years 1999 - 2009."}, 
  { name: 'Deaths', description: "Information from the City of Chicago relating to cumulative number of deaths, average number of deaths, infant mortality rates, and other death-related data by community area for the years 2004 - 2008." },
  { name: 'Environmental Health', description: "Information from the City of Chicago relating to elevated blood lead level in blood tests on children aged 0-6 years by community area for the years 2004 - 2008." },
  { name: 'Infectious disease', description: "Information from the City of Chicago relating to cases of tuberculosis, gonorrhea, and other diseases. Data covers various time periods." },
  { name: 'Chronic disease', description: "Information from the City of Chicago relating to diabetes and asthma by zip code for the years 2000 - 2011." },
  { name: 'Crime', description: "Information from the Chicago Police Department by community area for years 2001-2013" },
  { name: 'Demographics', description: "Information from the US Census on population." }
])

chicago = Geography.new(
  :geo_type => "City",
  :name => 'Chicago',
  :slug => 'chicago',
  :geometry => ''
)
chicago.id = 100
chicago.save!
