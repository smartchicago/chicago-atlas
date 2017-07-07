class ResourceParser < Parser

  FIRST_ROW       = 2

  COLUMNS_HEADER  = {
    category:     'A',
    subcategory:  'B',
    indicator:    'C',
    year:         'D',
    geography:    'E',
    geo_group:    'F',
    geo_id:       'G',
    demography:   'H',
    demo_group:   'I'
  }

  COLUMNS = [
    'number',
    'cum_number',
    'ave_annual_number',
    'crude_rate',
    'lower_95ci_crude_rate',
    'upper_95ci_crude_rate',
    'age_adj_rate',
    'lower_95ci_adj_rate',
    'upper_95ci_adj_rate',
    'percent',
    'lower_95ci_percent',
    'upper_95ci_percent',
    'weight_number',
    'weight_percent',
    'lower_95ci_weight_percent',
    'upper_95ci_weight_percent',
    'map_key',
    'flag'
  ]

  #Main engine for analyse of excel file
  def run
    parse do
      self.current_sheet.processing!
      ss = Roo::Spreadsheet.open(self.new_file_path)

      current_uploader             = Uploader.find(self.uploader_id)
      work_count                   = 0
      total_count                  = ss.last_row - 1
      current_uploader.update_total_row(total_count)

      FIRST_ROW.upto ss.last_row do |row|
        category_slug     = ss.cell(row, COLUMNS_HEADER[:category]).to_s.tr(' ', '-').downcase
        sub_category_slug = ss.cell(row, COLUMNS_HEADER[:subcategory]).to_s.tr(' ', '-').downcase
        indicator_slug    = ss.cell(row, COLUMNS_HEADER[:indicator]).to_s.tr(' ', '-').downcase
        demography_slug   = (ss.cell(row, COLUMNS_HEADER[:demo_group]).to_s.tr(' ', '-').downcase + ss.cell(row, COLUMNS_HEADER[:demography]).to_s.tr(' ', '-').downcase).tr(' ', '-').downcase

        category     =  CategoryGroup.where(name: ss.cell(row, COLUMNS_HEADER[:category]).to_s, slug: category_slug).first_or_create
        sub_category =  SubCategory.where(name: ss.cell(row, COLUMNS_HEADER[:subcategory]).to_s, category_group_id: category.id, slug: sub_category_slug).first_or_create
        indicator    =  Indicator.where(name: ss.cell(row, COLUMNS_HEADER[:indicator]), sub_category_id: sub_category.id, slug: indicator_slug).first_or_create
        geography    =  GeoGroup.where(name: ss.cell(row, COLUMNS_HEADER[:geo_group]), geography: ss.cell(row, COLUMNS_HEADER[:geography])).first_or_create
        demography   =  DemoGroup.where(name: ss.cell(row, COLUMNS_HEADER[:demo_group]), demography: ss.cell(row, COLUMNS_HEADER[:demography]), slug:demography_slug).first_or_create

        new_resource                    =   Resource.new
        new_resource.uploader_id        =   self.uploader_id
        new_resource.category_group_id  =   category.id
        new_resource.sub_category_id    =   sub_category.id
        new_resource.indicator_id       =   indicator.id
        new_resource.geo_group_id       =   geography.id
        new_resource.demo_group_id      =   demography.id
        str_year                        =   ss.cell(row, COLUMNS_HEADER[:year]).to_s
        
        if (str_year.include? '-') || (str_year.length == 9)
          new_resource.year_from = str_year[0,4].to_i
          new_resource.year_to   = str_year[5,8].to_i
        else
          new_resource.year_from = str_year.to_i
          new_resource.year_to   = str_year.to_i
        end

        rsc_array   = -1
        rsc_array.upto COLUMNS.length-1 do |rsc_id|
          rsc_start = 7
          rsc_start.upto ss.last_column do |col_id|
            if COLUMNS[rsc_id].casecmp(ss.cell(1, col_id)) == 0
              new_resource[COLUMNS[rsc_id]] = ss.cell(row, col_id)
              break
            end
          end
        end

        if new_resource.save
          work_count+= 1
          current_uploader.update_current_state(work_count)
          current_uploader.update_indicator(indicator.id)
        else
          self.current_sheet.failed!
        end
      end
    end
    self.current_sheet.completed!
  end

  #initialize resource class
  def self.run(uploader_id)
    ResourceParser.new(uploader_id).run
  end
end
