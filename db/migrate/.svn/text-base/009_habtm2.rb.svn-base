class Habtm2 < ActiveRecord::Migration
  def self.up
    drop_table :lists_to_talks rescue nil
    drop_table :lists_talks rescue nil
    create_table :lists_talks do |t|
      t.column :talk_id, :integer
      t.column :list_id, :integer
    end rescue nil
  end

  def self.down
    drop_table :lists_to_talks rescue nil
  end
end
