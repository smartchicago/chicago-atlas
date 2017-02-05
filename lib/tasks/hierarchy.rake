namespace :db do
  namespace :import do
    desc 'Import hierarchy data from local file'
    task :hierarchy =>  :environment do
      require 'csv'
      require 'json'

      AreaPart.delete_all
      FIRST_ROW = 2

      ss = Roo::Spreadsheet.open("db/import/CommunityAreas.xlsx")

      FIRST_ROW.upto ss.last_row do |row|
        id = ss.cell(row, 1)
        area = ss.cell(row, 2)
        side = ss.cell(row, 3)
        new_name = ""
        new_name = new_name + id.to_s + '-' + area.to_s
        AreaPart.where(name: new_name, part: side).first_or_create
      end
    end
  end
end
