require 'script_helper'
require 'twitter'

@twitter = Twitter::Base.new('romeda+foocal@gmail.com', 'rainorshine')

def send_update(text)
  puts "sending update: #{text}"
#  @twitter.post(text)
end

now = (Time.now.utc - 7.hours)

sent_talks = File.read('/tmp/sent_talks') rescue ''
sent_talks = '-1' if sent_talks.blank?
upcoming_talks = Talk.find(:all, :conditions => ["start > ? and start <= ? AND id not in (#{sent_talks})", now, now + 15.minutes], :order => 'start asc')

updates_for_users = Hash.new([])

sent_talks = File.open('/tmp/sent_talks', 'a')

upcoming_talks.each do |talk|
  update_text = talk.bare_summary
  update_text << ", " + talk.location if !talk.location.blank?
  update_text << " in #{(talk.start - now).round / 60} mins."

  sent_talks.write("#{sent_talks.pos == 0 ? '' : ','}#{talk.id}")

  if talk.users.size > 0
    general_update = update_text + " (+#{talk.users.size} ppl)" if talk.users.si
  else
    general_update = update_text
  end
  send_update(general_update)

  talk.users.each do |user|
    updates_for_users[user.twitter_name] << update_text if user.twitter_name.any?
  end
end

sent_talks.close

updates_for_users.each do |user,updates|
  while updates.size > 0
    full_text = 'soon '
    while update.size > 0 && ("#{full_text} / #{updates[0]}".size <= 140 || full_text == 'soon ')
      new_update = updates.shift
      if new_update.size > 140
        new_update = new_update.gsub(/ in [0-9]+ mins.$/, '')
      end
      full_text << " / #{new_update}"
    end
    send_update("d #{user} #{full_text}")
  end
end

