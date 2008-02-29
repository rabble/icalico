require 'script_helper.rb'
require 'icalendar'
require 'date'
require 'breakpoint'
require 'pp'


file = ARGV.shift
cal_file = File.open(file)

cals = Icalendar.parse(cal_file)
cal = cals.first

cal.events.each do |event|
  event.summary.gsub!(/\s*\((.*)\)/, '')
  
  
#  event.description.gsub!( /\\[n]/, '<br />')
#  event.description.gsub!( /\\,/, ',')
  
  attrs = {   
   :url => event.url.to_s.strip,
   :uid => event.uid.strip,
   :summary => event.summary.strip,
   :description => event.description.strip,
   :start => event.dtstart,
   :end => event.dtend,
   :location => event.location.strip,
   :imported => true
  }
  
  if (Talk.find_by_uid(attrs[:uid]))
    puts "updating: #{attrs[:summary]}"
    talk = Talk.find_by_uid(attrs[:uid])
    talk.update_attributes(attrs) if talk  
  else
    puts "inserting #{attrs[:summary]}"
  
    talk = Talk.new(attrs)
    talk.save
  
    tags = Tag.extract_tags(talk.description)

    tags.each do |tag|
      talk.tags << tag unless talk.tags.include?(tag)
    end
    
    if (talk.description =~ /Track: (.+)/)
      track = $1.strip
      talk.tags << Tag.find_or_create(track)
    end
    
  end
    
  if (talk.description =~ /Speaker\(s\):\s*(.+)/)
    authors = $1.split(';')
    talk.speakers.clear unless authors.empty?
    authors.each do |a|
      puts "author: #{a}"
      a.strip!
      next if a.blank?
      speaker = Speaker.find_or_create_by_name(a)
      talk.speakers<< speaker
    end
  end
end

ActiveRecord::Base.connection.execute('update talks set start_date = DATE(start), start_time = DATE_FORMAT(start, "%H:%i");')
ActiveRecord::Base.connection.execute('update talks set end_date = DATE(end), end_time = DATE_FORMAT(end, "%H:%i");')
