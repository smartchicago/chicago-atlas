class ProviderStats < ActiveRecord::Base
  attr_accessible :src_id, :stat_type, :stat, :value, :year, :time_period
end
