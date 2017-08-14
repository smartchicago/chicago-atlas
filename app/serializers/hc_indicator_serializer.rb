class HcIndicatorSerializer < ActiveModel::Serializer
  attributes :name, :id, :rows

  def name
    object[0]
  end

  def id
    object[0]
  end

  def rows
    object[1].map do |indictor_element|
      HcIndicatorElementSerializer.new(indictor_element)
    end
  end
end
