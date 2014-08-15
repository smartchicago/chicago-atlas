# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

categories = Category.create([
  { name: 'Births', description: "Information from the City of Chicago relating to number of births, fertility rates, teen births, and other birth-related data by community area for the years 1999 - 2009."}, 
  { name: 'Deaths', description: "Information from the City of Chicago causes of death and infant mortality rates by community area for the years 2005 - 2009." },
  { name: 'Environmental Health', description: "Information from the City of Chicago relating to elevated blood lead level in blood tests on children aged 0-6 years by community area for the years 1999 - 2011." },
  { name: 'Infectious Disease', description: "Information from the City of Chicago relating to cases of tuberculosis, gonorrhea, and other diseases. Data covers various time periods." },
  { name: 'Chronic Disease', description: "Information from the City of Chicago and the Chicago Health Information Technology Regional Extension Center (CHITREC) relating to chronic diseases by zip code. Data covers various time periods." },
  { name: 'Crime', description: "Reported crime from the Chicago Police Department by community area for years 2003-2013." },
  { name: 'Demographics', description: "Information from the US Census on population and demographics by community area and zip code." },
  { name: 'Healthcare Providers', description: "Healthcare providers by community area. Data covers various time periods." }
  { name: 'Hospital Admissions', description: "Inpatient & outpatient hospital admissions by patient zip code."}
])

chicago = Geography.new(
  :geo_type => "City",
  :name => 'Chicago',
  :slug => 'chicago',
  :geometry => ''
)
chicago.id = 100
chicago.save!
