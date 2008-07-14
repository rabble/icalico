class CreateTalks < ActiveRecord::Migration
  def self.up
    create_table :talks do |t|
      t.column :summary, :string
      t.column :description, :text
      t.column :start, :datetime
      t.column :end, :datetime
      t.column :location, :string
      t.column :uid, :string
      t.column :url, :string
    end
  end

  def self.down
    drop_table :talks
  end
end
