class AddIndex < ActiveRecord::Migration
  def self.up
    add_index :talks, :start_date
    add_index :talks_profiles, [:talk_id, :profile_id], 'unique'
  end

  def self.down
  end
end
