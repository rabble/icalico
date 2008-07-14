class AddTalkCreatorId < ActiveRecord::Migration
  def self.up
    add_column :talks, :creator_id, :integer
  end

  def self.down
    remove_column :talks, :creator_id
  end
end
