class AddTalkCapacity < ActiveRecord::Migration
  def self.up
    add_column :talks, :capacity, :integer
  end

  def self.down
    remove_column :talks, :capacity
  end
end
