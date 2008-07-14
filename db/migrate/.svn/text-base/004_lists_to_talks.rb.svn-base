class ListsToTalks < ActiveRecord::Migration
  def self.up
    create_table :lists_to_talks do |t|
      t.column :list_id, :integer
      t.column :talk_id, :integer
    end
  end

  def self.down
    drop_table :lists_to_talks
  end
end
