namespace :db do
  namespace :import do    
    namespace :set_visibility do 

      desc "Set visibility of imported datasets"
      task :all => :environment do
        
        to_hide = [
          "Population ALL 00-04",
          "Population ALL 05-14",
          "Population ALL 15-24",
          "Population ALL 25-34",
          "Population ALL 35-44",
          "Population ALL 45-54",
          "Population ALL 55-64",
          "Population ALL 65-74",
          "Population ALL 75-84",
          "Population ALL 85+",
          "Population ALL TOTAL",
          "Population FEMALE 00-04",
          "Population FEMALE 05-14",
          "Population FEMALE 15-24",
          "Population FEMALE 25-34",
          "Population FEMALE 35-44",
          "Population FEMALE 45-54",
          "Population FEMALE 55-64",
          "Population FEMALE 65-74",
          "Population FEMALE 75-84",
          "Population FEMALE 85+",
          "Population FEMALE TOTAL",
          "Population MALE 00-04",
          "Population MALE 05-14",
          "Population MALE 15-24",
          "Population MALE 25-34",
          "Population MALE 35-44",
          "Population MALE 45-54",
          "Population MALE 55-64",
          "Population MALE 65-74",
          "Population MALE 75-84",
          "Population MALE 85+",
          "Population MALE TOTAL",
          "Asian All ages Uninsured",
          "Black All ages Uninsured",
          "Enrolled in school 19 to 25 Uninsured",
          "Latino All ages Uninsured",
          "Not enrolled 19 to 25 Uninsured",
          "138 to 199% All ages Uninsured",
          "200 to 399% All ages Uninsured",
          "400% and over All ages Uninsured",
          "Foreign-Born Citizen Uninsured",
          "Foreign-Born Noncitizen Uninsured",
          "Foreign-Born Uninsured",
          "Native-Born Uninsured",
          "0 to 138% All ages Uninsured",
          "White NL All ages Uninsured"
        ]

        to_hide.each do |h|
          puts "hiding '#{h}'"
          d = Dataset.where(:name => h).first
          d.is_visible = false
          d.save
        end

      end
    end
  end
end