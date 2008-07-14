class Tag < ActiveRecord::Base
  has_and_belongs_to_many :talks, :uniq => true
  
  @@valid_tags = [
    'Javascript', 'Ajax', 'Java', 'Business', 'Ruby', 'Security', 'Python', 
    'Programming', 'PHP', 'Perl', 'Windows', 'Linux','Rails', 'Community',
    'wiki', 'blog', 'microformats', 'tagging', 'syndication',  
  ]
  
  def self.extract_tags(text_string)
    words = text_string.split(/\s*\b\s*/ )
    tags = []
    
    words.each do |word|
      if @@valid_tags.include?(word)
        tags << Tag.find_or_create(word)
      end
    end
    return tags
  end
  
  def self.find_popular(n=50)
    sql = "select t.*, count(j.tag_id) as popularity from tags t, tags_talks j, talks tk"
    sql << " where t.id = j.tag_id and t.name is not null and talk_id = tk.id and tk.conference_id = #{conference.id} group by j.tag_id order by popularity desc limit #{n}"
    @tags = Tag.find_by_sql(sql)
    # re-sort by date
    
    return @tags.sort_by {|tag| tag.name}
  end
  
  def self.find_speakers(n=300)
    sql = "select t.*, count(j.tag_id) as popularity from tags t, tags_talks j"
    sql << " where t.id = j.tag_id and t.name like '%\\\_%' group by j.tag_id order by popularity desc limit #{n}"
    @tags = Tag.find_by_sql(sql)
    # re-sort by date
    return @tags.sort_by {|tag| tag.name}
  end
  
  def self.find_or_create(tag_name)
    tag = Tag.find(:first, :conditions => ["name = ?", tag_name])
    return tag if tag
    
    tag = Tag.create(:name => tag_name)
    tag.save
    return tag
  end
  
  def name_pretty
    return name.gsub(/_/, ' ')
  end
  
end
