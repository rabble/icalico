class ImportField < ActiveRecord::Migration
  def self.up
    add_column :talks, :imported, :boolean
  end

  def self.down
  end
end
