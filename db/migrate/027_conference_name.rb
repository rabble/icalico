class ConferenceName < ActiveRecord::Migration
  def self.up
    add_column :conferences, :name, :string
# TODO: 2008-03-11 <tony@tonystubblebine.com> -- This is CV specific
    #add_column :conferences, :subdomain, :string
    add_column :conferences, :site_id, :integer
  end

  def self.down
    drop_column :conferences, :name, :string
    #drop_column :conferences, :subdomain, :string
    drop_column :conferences, :site_id
  end
end
