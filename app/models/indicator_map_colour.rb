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
      else
        []
      end
    end
  end

  def self.default_quintile
   return [
            { start: 0, end: 50, color: '#CCDFEB' },
            { start: 51, end: 65, color: '#92C2DF' },
            { start: 66, end: 80, color: '#6AA3CE' },
            { start: 81, end: 95, color: '#4D81B7' },
            { start: 96, end: 110, color: '#4474a7' }
          ]
  end

end
