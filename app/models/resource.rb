class Resource < ActiveRecord::Base
  belongs_to :uploader
  belongs_to :category_group
  belongs_to :sub_category
  belongs_to :demo_group
  belongs_to :geo_group
  belongs_to :indicator

  validates :uploader_id, presence: true


  def self.parse_year(year)
    year_from = nil
    year_to = nil
    if (year.to_s.include? '-') || (year.to_s.length == 9)
      year_from = year[0,4].to_i
      year_to   = year[5,8].to_i
    else
      year_from = year.to_i
      year_to   = year.to_i
    end
    [year_from, year_to]
  end
end
