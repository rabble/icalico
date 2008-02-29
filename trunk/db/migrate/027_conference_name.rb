class ConferenceName < ActiveRecord::Migration
  def self.up
    add_column :conferences, :name, :string
    add_column :conferences, :subdomain, :string
  end

  def self.down
    drop_column :conferences, :name, :string
    drop_column :conferences, :subdomain, :string
  end
end
