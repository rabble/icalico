class Day < ActiveRecord::Base
  attr :start_date
  def self.days
    Day.find_by_sql("select start from talks group by start_date")
  end
end
