class AddExternalId < ActiveRecord::Migration
  def self.up
    add_column :users, :external_id, :integer
  end

  def self.down
    drop_column :users, :external_id, :integer
  end
end
