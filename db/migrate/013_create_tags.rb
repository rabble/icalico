class CreateTags < ActiveRecord::Migration
  def self.up
    drop_table :tags rescue nil
    create_table :tags do |t|
      t.column :name, :string
    end
    
    
    valid_tags = ['JavaScript' 'Ajax', 'Java', 'Business', 'Web Apps', 'Ruby', 'Security', 'Python', 
        'Programming', 'PHP', 'Perl', 'Windows', 'Linux', 'Emerging Topics', 'Databases', 
        'Desktop Apps', 'Products and Services', 'Subversion', 'Rails', 'vim']
        
    valid_tags.each do |t|
      Tag.create({:name=> t.downcase}).save
    end
  end

  def self.down
    drop_table :tags rescue nil
  end
end
