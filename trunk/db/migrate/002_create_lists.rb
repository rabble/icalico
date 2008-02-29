class CreateLists < ActiveRecord::Migration
  def self.up
    create_table :lists do |t|
      t.column :user_id, :integer
      t.column :name, :string
    end
  end

  def self.down
    drop_table :lists
  end
end
