class AddDenormalizedDateFields < ActiveRecord::Migration
  def self.up
    add_column :talks, :start_date, :string
    add_column :talks, :end_date, :string
    add_column :talks, :start_time, :string
    add_column :talks, :end_time, :string
  end

  def self.down
    drop_column :talks, :start_date
    drop_column :talks, :end_date
    drop_column :talks, :start_time
    drop_column :talks, :end_time
    
  end
end
