class DenormalizeDateFields < ActiveRecord::Migration
  def self.up
    execute('update talks set start_date = DATE(start), start_time = DATE_FORMAT(start, "%H:%i");')
    execute('update talks set end_date = DATE(end), end_time = DATE_FORMAT(end, "%H:%i");')
  end

  def self.down
  end
end
