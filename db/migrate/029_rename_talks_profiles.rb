class RenameTalksProfiles < ActiveRecord::Migration
  def self.up
    rename_table(:talks_profiles, :profiles_talks)
  end

  def self.down
    rename_table(:profiles_talks, :talks_profiles)
  end
end
