class Habtm < ActiveRecord::Migration
  
  
  def self.up
    drop_table :lists_to_talks rescue nil
    drop_table :attendances rescue nil
    create_table :lists_to_talks do |t|
      t.column :talk_id, :integer
      t.column :list_id, :integer
    end    
  end

  def self.down
    drop_table :lists_to_talks rescue nil
    create_table :attendances do |t|
      t.column :talk_id, :integer
      t.column :list_id, :integer
    end
  end

end
