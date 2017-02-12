namespace :db do
  namespace :import do
    desc 'Import hierarchy data from local file'
    task :hierarchy =>  :environment do
      require 'csv'
      require 'json'

      FIRST_ROW = 2

      ss = Roo::Spreadsheet.open("db/import/hierarchy.xlsx")

      FIRST_ROW.upto ss.last_row do |row|
        id    = ss.cell(row, 1)
        area  = ss.cell(row, 2)
        side  = ss.cell(row, 3)
        name  = ""
        name  = name + id.to_s + '-' + area.to_s
        field = GeoGroup.find_by_name(name)
        unless field.nil?
          field.update(:part => side)
        end

        field = Geography.find_by_name(area)
        unless field.nil?
          field.update(:part => side)
        end
      end
    end
  end
end
