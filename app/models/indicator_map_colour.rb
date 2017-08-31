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
    indicator_map_colours = IndicatorMapColour.where(slug: indicator_slug).order(start_value: :asc)
    unless indicator_map_colours.empty?
      colours = []
      indicator_map_colours.each do |imc|
        colours.push({start: imc.start_value, end: imc.end_value, color: imc.colour})
      end
      colours
    else
      if map_key.downcase == 'quintile' || map_key.downcase == 'quintiles'
        self.default_quintile
      elsif map_key.downcase == 'quartile' || map_key.downcase == 'quartiles'
        self.default_quartile
      elsif map_key.downcase == 'tertile' || map_key.downcase == 'tertile'
        self.default_tertile
      else
        []
      end
    end
  end

  def self.default_tertile
   return [
            { start: 0, end: 99, color: '#E8F0F5' },
            { start: 100, end: 199, color: '#83ABCC' },
            { start: 200, end: 299, color: '#25426F' }
          ]
  end

  def self.default_quartile
   return [
            { start: 0, end: 99, color: '#F3F7FA' },
            { start: 100, end: 199, color: '#CADBE7' },
            { start: 200, end: 299, color: '#83ABCC' },
            { start: 300, end: 399, color: '#25426F' },
          ]
  end

  def self.default_quintile
   return [
            { start: 0, end: 99, color: '#F3F7FA' },
            { start: 100, end: 199, color: '#CADBE7' },
            { start: 200, end: 299, color: '#83ABCC' },
            { start: 300, end: 399, color: '#3E6C9A' },
            { start: 400, end: 499, color: '#25426F' }
          ]
  end

end
