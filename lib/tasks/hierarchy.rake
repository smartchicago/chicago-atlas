namespace :db do
  namespace :import do
    namespace :hierarchy do
      desc 'Import hierarchy data from local file'
      task :all =>  :environment do
        require 'csv'
        require 'json'
        
      end
    end
  end
end
