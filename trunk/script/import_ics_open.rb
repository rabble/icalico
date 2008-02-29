require 'script_helper.rb'
require 'icalendar'
require 'date'
require 'breakpoint'
require 'pp'


room = 'Beta'

web2open = Tag.find_or_create("web2open");

room = ARGV.shift
file = ARGV.shift
cal_file = File.open(file)

cals = Icalendar.parse(cal_file)
cal = cals.first

cal.events.each do |event|
  event.summary.gsub!(/\s*\((.*)\)/, '')
  
  talk = Talk.new(
    :summary => event.summary,
    :start => event.dtstart,
    :end => event.dtend,
    :description => event.summary,
    :uid => event.uid,
    :location => room,
    :imported => true,
    :url => 'http://www.socialtext.net/web2open/index.cgi?web2open'
  )
  
  talk.save
  
  talk.tags << web2open

end
  
ActiveRecord::Base.connection.execute('update talks set start_date = DATE(start), start_time = DATE_FORMAT(start, "%H:%i");')
ActiveRecord::Base.connection.execute('update talks set end_date = DATE(end), end_time = DATE_FORMAT(end, "%H:%i");')
