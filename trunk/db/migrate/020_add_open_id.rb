class AddOpenId < ActiveRecord::Migration
  def self.up
    add_column :users, :openid, :string
    add_index :users, [:openid], :name => :users_openid_index, :unique => true
  end

  def self.down
    remove_column :users, :openid
  end
end
