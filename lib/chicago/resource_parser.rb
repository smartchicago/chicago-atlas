class ResourceParser < Parser

  FIRST_ROW                      = 2
  FIRST_ROW_DESCRIPTION_TEMPLATE = 3
  FIRST_ROW_RESOURCES            = 2
  FIRST_INDICATOR_MAP_COLOR      = 2

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

  HC_COLUMNS_HEADER  = {
    category:        'A',
    indicator:       'B',
    year:            'C',
    population:      'D',
    population_year: 'E',
    target:          'F',
    datasource:      'G',
    datasource_url:  'H'
  }

  DESCRIPTION_TEMPLATE_HEADER  = {
    indicator:       'E',
    description:     'F',
    order:           'O'
  }

  RESOURCES_HEADER  = {
    name:             'A',
    address:          'D',
    city:             'F',
    zip_code:         'G',
    community_area:   'H',
    categories:       'L',
    phone:            'N',
    program_url:      'P',
    latitude:         'Q',
    longitude:        'R'
  }

  INDICATOR_MAP_COLOR_HEADER  = {
    indicator:   'A',
    year:        'B',
    type:        'C',
    range_start: 'D',
    range_end:   'E',
    color:       'F'
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
      total_count                  = ss.last_row - 1
      current_uploader.update_total_row(total_count)
      case current_uploader.category
        when Uploader::TYPES[:default]
          upload_indicator(ss, current_uploader)
        when Uploader::TYPES[:indicator_2_0]
          upload_health_care_indicators(ss, current_uploader)
        when Uploader::TYPES[:resources]
          upload_resources(ss, current_uploader)
        when Uploader::TYPES[:indicator_map_color]
          upload_indicators_map_color(ss, current_uploader)
        else
          upload_description_template(ss, current_uploader)
      end
    end
    self.current_sheet.completed!
  end

  def upload_indicator ss, uploader
    work_count = 0
    FIRST_ROW.upto ss.last_row do |row|
      category_slug     = ss.cell(row, COLUMNS_HEADER[:category]).to_s.tr(' ', '-').downcase
      sub_category_slug = ss.cell(row, COLUMNS_HEADER[:subcategory]).to_s.tr(' ', '-').downcase
      indicator_name    = ss.cell(row, COLUMNS_HEADER[:indicator]).to_s
      indicator_slug    = CGI.escape(indicator_name.tr(' ', '-').tr('/', '-').tr(',', '-').downcase)
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
          name_attr = COLUMNS[rsc_id]
          name_attr = 'lower_95ci_age_adj_rate' if COLUMNS[rsc_id] == 'lower_95ci_adj_rate'
          name_attr = 'upper_95ci_age_adj_rate' if COLUMNS[rsc_id] == 'upper_95ci_adj_rate'
          if (name_attr.casecmp(ss.cell(1, col_id)) == 0)
            new_resource[COLUMNS[rsc_id]] = ss.cell(row, col_id)
            break
          end
        end
      end

      if new_resource.save
        work_count+= 1
        uploader.update_current_state(work_count)
        uploader.update_indicator(indicator.id)
      else
        self.current_sheet.failed!
      end
    end
  end

  def upload_health_care_indicators ss, uploader
    work_count = 0
    FIRST_ROW.upto ss.last_row do |row|
      name = ss.cell(row, HC_COLUMNS_HEADER[:indicator])
      indicator_slug = CGI.escape(name.to_s.tr(' ', '-').tr('/', '-').tr(',', '-').downcase)
      category = ss.cell(row, HC_COLUMNS_HEADER[:category])
      year    = ss.cell(row, HC_COLUMNS_HEADER[:year])
      population    = ss.cell(row, HC_COLUMNS_HEADER[:population])
      population_year    = ss.cell(row, HC_COLUMNS_HEADER[:population_year])
      target    = ss.cell(row, HC_COLUMNS_HEADER[:target])
      float_target = target.to_f
      if float_target <=1 && float_target > 0
        target =  ActionController::Base.helpers.number_to_percentage(target.to_f * 100, precision: 1)
      elsif float_target > 1000
        target = float_target / 1000
      end
      datasource    = ss.cell(row, HC_COLUMNS_HEADER[:datasource])
      datasource_url    = ss.cell(row, HC_COLUMNS_HEADER[:datasource_url])
      indicator    =  HcIndicator.create(name: name, slug: indicator_slug, category: category, most_recent_year: year,
              priority_population: population, priority_population_most_recent_year: population_year, target: target,
              datasource: datasource, datasource_url: datasource_url, uploader: uploader)
      work_count += 1
      uploader.update_current_state(work_count)
    end
    work_count
  end

  def upload_description_template ss, uploader
    work_count = 0
    IndicatorProperty.delete_all
    FIRST_ROW_DESCRIPTION_TEMPLATE.upto ss.last_row do |row|
      name = ss.cell(row, DESCRIPTION_TEMPLATE_HEADER[:indicator])
      indicator_slug = CGI.escape(name.to_s.tr(' ', '-').tr('/', '-').tr(',', '-').downcase)
      order    = ss.cell(row, DESCRIPTION_TEMPLATE_HEADER[:order])
      description    = ss.cell(row, DESCRIPTION_TEMPLATE_HEADER[:description])
      indicator    =  IndicatorProperty.create(name: name, slug: indicator_slug, description: description, order: order)
      work_count += 1
      uploader.update_current_state(work_count)
    end
    work_count
  end

  def upload_resources ss, uploader
    work_count = 0
    InterventionLocation.delete_all
    FIRST_ROW_RESOURCES.upto ss.last_row do |row|
      name = ss.cell(row, RESOURCES_HEADER[:name])
      address = ss.cell(row, RESOURCES_HEADER[:address])
      city = ss.cell(row, RESOURCES_HEADER[:city])
      zip_code = ss.cell(row, RESOURCES_HEADER[:zip_code])
      community_area_name = ss.cell(row, RESOURCES_HEADER[:community_area])
      categories = ss.cell(row, RESOURCES_HEADER[:categories])
      phone = ss.cell(row, RESOURCES_HEADER[:phone])
      program_url = ss.cell(row, RESOURCES_HEADER[:program_url])
      latitude = ss.cell(row, RESOURCES_HEADER[:latitude])
      longitude = ss.cell(row, RESOURCES_HEADER[:longitude])

      community_area = GeoGroup.find_by_slug(community_area_name.to_s.tr(' ', '-').downcase)
      community_area_id = community_area ? community_area.id : nil
      resource    =  InterventionLocation.create(program_name: name, address: address, city: city, zip: zip_code,
                                                 community_area_id: community_area_id, categories: categories, phone: phone,
                                                 program_url: program_url, latitude: latitude, longitude: longitude,
                                                 community_area_name: community_area_name)
      work_count += 1
      uploader.update_current_state(work_count)
    end
    work_count
  end

  def upload_indicators_map_color ss, uploader
    work_count = 0
    IndicatorMapColour.delete_all
    FIRST_INDICATOR_MAP_COLOR.upto ss.last_row do |row|
      indicator_name = ss.cell(row, INDICATOR_MAP_COLOR_HEADER[:indicator])
      indicator_slug = CGI.escape(indicator_name.to_s.tr(' ', '-').tr('/', '-').tr(',', '-').downcase)
      year = ss.cell(row, INDICATOR_MAP_COLOR_HEADER[:year])
      type = ss.cell(row, INDICATOR_MAP_COLOR_HEADER[:type])
      range_start = ss.cell(row, INDICATOR_MAP_COLOR_HEADER[:range_start])
      range_end = ss.cell(row, INDICATOR_MAP_COLOR_HEADER[:range_end])
      color = ss.cell(row, INDICATOR_MAP_COLOR_HEADER[:color])
      indicator_map_colour = IndicatorMapColour.create(name: indicator_name, slug: indicator_slug, map_key: type, start_value: range_start.to_s,
                                                       end_value: range_end.to_s, colour: color, year: year )
      work_count += 1
      uploader.update_current_state(work_count)
    end
    work_count
  end

  #initialize resource class
  def self.run(uploader_id)
    ResourceParser.new(uploader_id).run
  end
end
