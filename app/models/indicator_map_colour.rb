class IndicatorMapColour < ActiveRecord::Base

  def self.map_type_string(indicator, indicator_map_colour)
    if indicator_map_colour
      indicator_map_colour.map_key
    elsif indicator
      resource = Resource.where(indicator_id: indicator.id)
                  .where.not(geo_group_id: GeoGroup.find_by_geography('City'))
                  .where.not(map_key: '').first
      resource.try(:map_key) || 'quintile'
    else
      ''
    end
  end

  def self.map_type_colours(indicator_slug, map_key)
    indicator_map_colours = IndicatorMapColour.where(slug: indicator_slug)
    colours = []
    unless indicator_map_colours.empty?
      indicator_map_colours.each do |imc|
        colours.push({year: imc.year, start: imc.start_value.to_f, end: imc.end_value.to_f, color: imc.colour})
      end
      colours
    end
    if map_key.downcase == 'quintile' || map_key.downcase == 'quintiles'
      colours + self.default_quintile
    elsif map_key.downcase == 'quartile' || map_key.downcase == 'quartiles'
      colours + self.default_quartile
    elsif map_key.downcase == 'tertile' || map_key.downcase == 'tertile'
      colours + self.default_tertile
    else
      colours
    end
  end

  def self.default_tertile
   return [
            { year: 'default', start: 0, end: 40, color: '#F3F7FA' },
            { year: 'default', start: 40, end: 80, color: '#CADBE7' },
            { year: 'default', start: 80, end: 50, color: '#83ABCC' }
          ]
  end

  def self.default_quartile
   return [
            { year: 'default', start: 0, end: 40, color: '#F3F7FA' },
            { year: 'default', start: 40, end: 80, color: '#CADBE7' },
            { year: 'default', start: 80, end: 50, color: '#83ABCC' },
            { year: 'default', start: 80, end: 120, color: '#3E6C9A' }
          ]
  end

  def self.default_quintile
   return [
            { year: 'default', start: 0, end: 40, color: '#F3F7FA' },
            { year: 'default', start: 40, end: 80, color: '#CADBE7' },
            { year: 'default', start: 80, end: 50, color: '#83ABCC' },
            { year: 'default', start: 80, end: 120, color: '#3E6C9A' },
            { year: 'default', start: 120, end: 150, color: '#25426F' }
          ]
  end

end
