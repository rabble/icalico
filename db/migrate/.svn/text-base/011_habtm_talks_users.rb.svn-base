class HabtmTalksUsers < ActiveRecord::Migration
  def self.up
     create_table :talks_profiles do |t|
        t.column :talk_id, :integer
        t.column :profile_id, :integer
      end
  end

  def self.down
    drop_table :talks_profiles rescue nil
  end
end
