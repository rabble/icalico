class AddIndex < ActiveRecord::Migration
  def self.up
    add_index :talks, :start_date
    add_index :talks_users, [:talk_id, :user_id], 'unique'
    add_index :users, :login, 'unique'
  end

  def self.down
  end
end
