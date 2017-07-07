namespace :db do
  namespace :import do    
    namespace :categories do 

      desc "Ensure that all categories are created"
      task :all => :environment do

        categories = [
          { name: 'Births', description: "Information from the City of Chicago relating to number of births, fertility rates, teen births, and other birth-related data by community area for the years 1999 - 2009."}, 
          { name: 'Deaths', description: "Information from the City of Chicago causes of death and infant mortality rates by community area for the years 2005 - 2009." },
          { name: 'Environmental Health', description: "Information from the City of Chicago relating to elevated blood lead level in blood tests on children aged 0-6 years by community area for the years 1999 - 2011." },
          { name: 'Infectious Disease', description: "Information from the City of Chicago relating to cases of tuberculosis, gonorrhea, and other diseases. Data covers various time periods." },
          { name: 'Chronic Disease', description: "Information from the City of Chicago and the Chicago Health Information Technology Regional Extension Center (CHITREC) relating to chronic diseases by zip code. Data covers various time periods." },
          { name: 'Crime', description: "Reported crime from the Chicago Police Department by community area for years 2003-2013." },
          { name: 'Demographics', description: "Information from the US Census on population and demographics by community area and zip code." },
          { name: 'Healthcare Providers', description: "Healthcare providers by community area. Data covers various time periods." },
          { name: 'Dentists', description: "Dentists by zip code." },
          { name: 'Hospital Admissions Inpatient', description: "Inpatient hospital admissions by patient zip code."},
          { name: 'Hospital Admissions Outpatient', description: "Outpatient hospital admissions by patient zip code."},
          { name: 'Injuries Among Outpatient Admissions', description: "Injuries among outpatient hospital admissions"}
        ]

        categories.each do |cat|
          if Category.where("name = '#{cat[:name]}'").present?
            puts "#{cat[:name]} already present"
          else
            new_cat = Category.new(
              :name => cat[:name],
              :description => cat[:description]
              ) 
            puts "creating category: #{cat[:name]}"
            new_cat.save!
          end
        end
        puts "Done!"

      end
    end
  end
end

