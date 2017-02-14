namespace :db do
  namespace :import do

    desc "Fetch and import all geography, demographic and health data"
    task :all => :environment do
      Rake::Task["db:import:categories:all"].invoke
      Rake::Task["db:import:geography:community_areas"].invoke
      Rake::Task["db:import:geography:chicago_geo"].invoke
      Rake::Task["db:import:geography:zip_codes"].invoke
      Rake::Task["db:import:census:population"].invoke
      Rake::Task["db:import:stats"].invoke
      Rake::Task["db:import:purple_binder:all"].invoke
      Rake::Task["db:import:providers"].invoke
      Rake::Task["db:import:geo_group"].invoke
      Rake::Task["db:import:hierarchy"].invoke
    end

    desc "Fetch and import all health data"
    task :stats => :environment do
      Rake::Task["db:import:chicago:dph"].invoke
      Rake::Task["db:import:chicago:crime"].invoke
      Rake::Task["db:import:chitrec:all"].invoke
      Rake::Task["db:import:insurance:all"].invoke
      Rake::Task["db:import:dentists:all"].invoke
      Rake::Task["db:import:physicians:all"].invoke
      Rake::Task["db:import:inpatient_outpatient:inpatient"].invoke
      Rake::Task["db:import:inpatient_outpatient:outpatient"].invoke
      Rake::Task["db:import:injuries:injuries_outpatient"].invoke
    end

    desc "Import all provider data"
    task :providers => :environment do
      Rake::Task["db:import:providers:hospitals"].invoke
      Rake::Task["db:import:providers:hda"].invoke
      Rake::Task["db:import:provider_stats:all"].invoke
    end

  end
end
