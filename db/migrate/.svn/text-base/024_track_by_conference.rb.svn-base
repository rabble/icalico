class TrackByConference < ActiveRecord::Migration
  def self.up
    add_column :speakers, :conference_id, :integer
    add_column :tags, :conference_id, :integer
    add_column :talks, :conference_id, :integer
  end

  def self.down
    drop_column :speakers, :conference_id, :integer
    drop_column :tags, :conference_id, :integer
    drop_column :talks, :conference_id, :integer
  end
end
