class CreateConferences < ActiveRecord::Migration
  def self.up
    create_table :conferences do |t|
      # t.column :name, :string
    end
  end

  def self.down
    drop_table :conferences
  end
end
