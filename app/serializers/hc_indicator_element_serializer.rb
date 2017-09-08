class HcIndicatorElementSerializer < ActiveModel::Serializer
  attributes :indicator, :indicator_slug, :description, :citywide_baseline,
             :priority_population, :priority_baseline, :target, :source

  def indicator
    object.name
  end

  def indicator_slug
    object.slug
  end

  def description
    'No description in excel'
  end

  def citywide_baseline
    object.most_recent_year
  end

  def priority_population
    object.priority_population
  end

  def priority_baseline
    object.priority_population_most_recent_year
  end

  def target
    object.target
  end

  def source
    { datasource: object.datasource, datasource_url: object.datasource_url }
  end
end
