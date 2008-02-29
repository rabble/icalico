class AddUserLink < ActiveRecord::Migration
  def self.up
    add_column :users, :url, :string
  end

  def self.down
    remove_column :users, :url rescue nil
  end
end
