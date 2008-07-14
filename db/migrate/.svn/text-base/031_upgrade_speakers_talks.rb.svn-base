class UpgradeSpeakersTalks < ActiveRecord::Migration
  def self.up
    execute("alter table speakers_talks add id int(11) primary key auto_increment")
    add_column :speakers_talks, :created_at, :timestamp
    add_column :speakers_talks, :updated_at, :timestamp
    add_column :speakers_talks, :name, :string
    execute("alter table speakers_talks rename speaker_talks")
    execute("alter table speaker_talks change column speaker_id profile_id int(11)")
  end

  def self.down
    remove_column :speaker_talks, :id
    remove_column :speaker_talks, :created_at
    remove_column :speaker_talks, :updated_at 
    remove_column :speaker_talks, :name
  end
end
