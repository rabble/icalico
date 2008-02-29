require 'chronic'

class Talk < ActiveRecord::Base

  validates_presence_of :summary
  validates_presence_of :description

  has_and_belongs_to_many :users, :uniq => true
  has_and_belongs_to_many :tags, :uniq => true
  has_and_belongs_to_many :speakers, :uniq => true
  
  belongs_to :creator, :class_name => 'User'
  belongs_to :conference

  attr_accessor :other_location, :day_str, :start_str, :end_str, :speakers_str
  
  before_save :parse_start_and_end, :setup_datetime, :set_conference, :set_location, :set_speakers
  
  #unless ENV['RAILS_ENV'] == 'test'
    acts_as_ferret(
      :fields => { 'summary'    => { :boost => 3 },
                   'description'=> { :boost => 2 },
                   'location' => { :boost => 1 }
                 },
      :store_class_name => true 
    )
  #end
  
  def self.next(n=20)
    @talks = conference.talks.find(:all, :conditions => 'start > DATE_SUB(NOW(), INTERVAL 195 MINUTE)', :order => 'start asc', :limit=>n)
  end

  def parse_start_and_end
    parsed_start = Chronic.parse(self.day_str + ' ' + self.start_str) if self.start_str
    parsed_end = Chronic.parse(self.day_str + ' ' + self.end_str) if self.end_str

    self.start = parsed_start if parsed_start
    self.end = parsed_end if parsed_end
  end

  def setup_datetime
    self.start_date= self.start.strftime('%F')
    self.start_time= self.start.strftime('%H:%M')
    self.end_date= self.end.strftime('%F')
    self.end_time= self.end.strftime('%H:%M')
  end

  def set_conference
    self.conference = ActiveRecord::Base.conference
  end

  def set_location
    self.location = self.other_location if self.location.empty? && !self.other_location.empty?
  end

  def set_speakers
    speakers_list = speakers_str.split(',').map!(&:strip)
    self.speakers.each do |speaker|
      self.speakers.delete(speaker) unless speakers_list.include?(speaker.name)
    end

    speakers_list.each do |name|
      speaker = Speaker.find_or_create_by_name(name)
      self.speakers << speaker
    end
  end

  def start_str
    if @start_str && @start_str.match(/^[0-9]+$/)
      "#{@start_str}:00"
    elsif @start_str
      @start_str
    elsif self.start.kind_of?(Time)
      self.start.strftime('%H:%M')
    else
      ''
    end
  end

  def end_str
    if @end_str && @start_str.match(/^[0-9]+$/)
      "#{@end_str}:00"
    elsif @end_str
      @end_str
    elsif self.end.kind_of?(Time)
      self.end.strftime('%H:%M')
    else
      ''
    end
  end

  def day_str
    return @day_str if @day_str
    return self.start.strftime("%B %d %Y") if self.start.kind_of?(Time)
    ''
  end

  def speakers_str
    return @speakers_str if @speakers_str
    self.speakers.map(&:name).join(', ')
  end

  def self.ferret_find(query, n=300)
    results = []
    results = find_by_contents(query, {:num_docs => n}) rescue nil
    return [] if( results.blank? && ! results.nil?)
    return results.sort {|x,y| x.start <=> y.start } 
  end

  def self.locations
    # hard_coded = ['tarsier (the werewolf room)', 'ant (building B 1st floor)', 'MAKE/CRAFT workshop (building B 1st floor)', 'smoking area', 
    #   'showers', 'alpaca (tent)', 'lemur (tent)', 
    #   'crab (tent)', 'platypus (tent)', 'jackal (tent)', 'rabbit (tent)', 'jaguar (building B 2nd floor)', 'reindeer (building B 3rd floor)', 'bat (the big room in building B 3rd floor)', 
    #   'camel (building B 3rd floor)', 'meerkat (building c 1st floor)', 'wallaby (building c 1st floor)', 'kitchen', 'big outside tent']
    
    locs = {}
    # hard_coded.each do |loc|
    #   locs[loc] = loc
    # end
    
    from_database = connection.select_values("SELECT DISTINCT location FROM talks where conference_id=#{conference.id}")
    from_database.each do |loc|
    	locs[loc] = loc
    end

    final_locs_array = []
    locs.each do |key,value|
    	final_locs_array<<key
    end
    return final_locs_array.sort

    
    
    
  end
  
  def find_related
    related = self.more_like_this({:field_names => ['summary', 'description'], :min_word_length => 3}) rescue nil
    now =Time.now
    future_related = related.find_all do |talk|
      talk.start > now
    end
    return  future_related.sort {|x,y| x.start <=> y.start }
  end
  
  def self.find_in_order
    conference.talks.find(:all, :order => 'start asc');
  end
  
  def self.find_by_date(start_date)
    conference.talks.find(:all, :conditions => ['start_date = ?', start_date], :order => 'start asc')
  end
  
  def self.find_popular(n=20)
    talks = self.find_popular_where("start >DATE_SUB(NOW(), INTERVAL 4 HOUR)", n)
#    sql = "select t.*, count(j.user_id) as popularity from talks t, talks_users j"
#    sql << " where t.id = j.talk_id and start >DATE_SUB(NOW(), INTERVAL 4 HOUR) "
#    sql << " group by j.talk_id order by popularity desc limit #{n}"
#    @talks = Talk.find_by_sql(sql)

    # re-sort by date
    return [] if talks.empty?
    return talks.sort_by {|talk| talk.start}
  end
  
  def self.find_popular_by_date(start_date, n=3)
    talks = self.find_popular_where(["start_date = ?" , start_date], n)
    
#    sql = "select t.*, count(j.user_id) as popularity from talks t, talks_users j"
#   sql << " where t.id = j.talk_id and start_date = '#{start_date}'"
#    sql << " group by j.talk_id order by popularity desc limit #{n}"
#    @talks = Talk.find_by_sql(sql)
 
    # re-sort by date
    return [] if talks.empty?
    return talks.sort_by {|talk| talk.start}
  end
  
  def self.find_by_tag(tag)
    sql = "select t.* from talks t, tags_talks j "
    sql << " where t.id = j.talk_id and j.tag_id = #{tag.id} group by j.talk_id order by start_date asc"
    return Talk.find_by_sql(sql)
  end
  
  def self.find_by_speaker(speaker)
    sql = "select t.* from talks t, speakers_talks j "
    sql << " where t.id = j.talk_id and j.speaker_id = #{speaker.id} group by j.talk_id order by t.start asc"
    return Talk.find_by_sql(sql)
  end

  def self.find_by_external_ids(external_ids)
    find_by_sql <<-END
    select t.*, j.user_id, u.login from talks t, talks_users j, users u 
    where t.id = j.talk_id and j.user_id = u.id 
    and u.external_id IN (#{external_ids}) order by t.start asc
    END
  end

  def interested
    self.users;
  end
  
  def bare_summary
    if (m = self.summary.match('"(.+)"')) 
      return m.captures[0]
    else
      return self.summary
    end
  end
  
  def bare_description
    if (m = self.description.match("Description: (.+)\n"))
      return m.captures[0]
    else
      return self.description
    end
  end
  
  def track
    if (m = self.description.match("Track: (.+)\n"))
      return m.captures[0]
    else
      return ''
    end
  end
  
  protected
    def self.find_popular_where(cond, n)
      conference.talks.find(:all, 
        :select => "talks.*, count(talks_users.user_id) as popularity",
        :joins  => "INNER JOIN talks_users ON talks.id = talks_users.talk_id",
        :group  => "talks_users.talk_id",
        :order  => "popularity DESC",
        :limit  => n,
        :conditions => cond
      )
    end
      
end
