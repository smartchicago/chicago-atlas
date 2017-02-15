namespace :db do
  namespace :import do
    desc 'Import geo_group data from local file'
    task :geo_group =>  :environment do
      require 'csv'
      require 'json'

      FIRST_ROW = 2
      
      ss = Roo::Spreadsheet.open("db/import/geo_group.xlsx")

      FIRST_ROW.upto ss.last_row do |row|
        geography  = ss.cell(row, 1)
        name       = ss.cell(row, 2)
        slug       = ss.cell(row, 3)

        field = GeoGroup.where(name: name, geography: geography, slug: slug).first_or_create
        field.save
      end
    end
  end
end
