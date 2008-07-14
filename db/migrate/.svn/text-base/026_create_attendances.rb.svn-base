class CreateAttendances < ActiveRecord::Migration
  def self.up
    create_table :attendances do |t|
      t.column :profile_id, :integer
      t.column :conference_id, :integer
    end
  end

  def self.down
    drop_table :attendances
  end
end
