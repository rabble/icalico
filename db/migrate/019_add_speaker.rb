class AddSpeaker < ActiveRecord::Migration
  def self.up
    drop_table :speakers_talks rescue nil
    drop_table :speakers rescue nil
    
    create_table(:speakers) do |t|
      t.column :name, :string
    end
    
    create_table(:speakers_talks, :id => false) do |t|
      t.column :speaker_id, :integer
      t.column :talk_id, :integer
    end    
  end

  def self.down
    drop_table :speakers rescue nil
    drop_table :speakers_talks rescue nil
  end
  
end
