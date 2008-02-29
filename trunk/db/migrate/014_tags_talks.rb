class TagsTalks < ActiveRecord::Migration
    def self.up
      drop_table :tags_talks rescue nil
      create_table(:tags_talks, :id => false) do |t|
        t.column :tag_id, :integer
        t.column :talk_id, :integer
      end    
    end

    def self.down
      drop_table :tags_talks rescue nil
    end
end
