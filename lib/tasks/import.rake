namespace :db do
  namespace :import do

    desc "Fetch and import all geography, demographic and health data"
    task :all => :environment do
      Rake::Task["db:import:geography:community_areas"].invoke
      Rake::Task["db:import:geography:zip_codes"].invoke
      Rake::Task["db:import:census:population"].invoke
      Rake::Task["db:import:stats"].invoke
      Rake::Task["db:import:purple_binder:all"].invoke
    end

    desc "Fetch and import all health data"
    task :stats => :environment do
      Rake::Task["db:import:chicago:dph"].invoke
      Rake::Task["db:import:chicago:crime"].invoke
      Rake::Task["db:import:chitrec:all"].invoke
    end

  end
end
