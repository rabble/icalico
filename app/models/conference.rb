class Conference < ActiveRecord::Base
  has_many :talks
  has_many :tags
  has_many :speakers
  belongs_to :site

  # TODO: 2008-04-26 <tony@tonystubblebine.com> -- Not sure if attendees is the
  # right word here. All the profiles are for an attendee, this is just the
  # ones that used the calendar.
  def attendees 
    User.find_by_sql("SELECT distinct(users.id), users.*
                         FROM users, talks_users, talks
                         WHERE talks.conference_id = #{self.id} 
                           AND talk_id = talks.id
                           AND users.id = user_id")
  end

  def subdomain
    site.short_name
  end

  def name
    site.name
  end

  def self.find_by_subdomain(subdomain)
    Conference.find_by_sql(["SELECT conferences.* 
                            FROM sites, conferences
                            WHERE short_name = ?
                                  AND site_id = sites.id", subdomain]).first
  end
end
