class Speaker < ActiveRecord::Base
  has_and_belongs_to_many :talks, :uniq => true
  
  def self.find_popular(n=50)
    sql = "select s.*, count(j.user_id)+1 as popularity from talks t, talks_users j, speakers s, speakers_talks j2"
    sql << " where t.id = j.talk_id and t.id = j2.talk_id and j2.speaker_id = s.id"
    sql << " group by j.talk_id order by popularity desc limit #{n}"
    
    sql = "select s.*, count(j2.user_id) as popularity FROM speakers s "
    sql << "LEFT JOIN speakers_talks j  ON (s.id=j.speaker_id) "
    sql << "LEFT JOIN talks t on (j.talk_id=t.id) "
    sql << "LEFT OUTER JOIN talks_users j2 on (j2.talk_id=t.id) group by j.speaker_id "
    sql << " order by popularity desc limit #{n}"
    
    @speakers = Speaker.find_by_sql(sql)
    
    return @speakers.sort_by {|speaker| speaker.name.to_s}
  end
  
end
