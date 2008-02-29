class HabtmTalksUsers < ActiveRecord::Migration
  def self.up
     create_table :talks_users do |t|
        t.column :talk_id, :integer
        t.column :user_id, :integer
      end
  end

  def self.down
    drop_table :talks_users rescue nil
  end
end
