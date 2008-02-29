class DropBadIds < ActiveRecord::Migration
  def self.up
    remove_column :talks_users, :id
    remove_column :friends, :id
  end

  def self.down
  end
end
