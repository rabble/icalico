#!/usr/local/bin/ruby
ENV["RAILS_ENV"] ||= 'development'
require File.dirname(__FILE__) + '/../../../../config/environment'
require 'ruby-debug'
require 'mechanize'
require 'icalendar'

include Icalendar

def parse_description(description)
  first = ""
  last = description
  if description.match(/^Presented by (.{5,280}?\)\))\.(.*)/) 
    first = $1
    last = $2
  elsif description.match(/^Presented by (.{5,280}?\))\.(.*)/) 
    first = $1
    last = $2
  elsif description.match(/^Presented by (.{5,280}? Solnik)\.(.*)/) 
  elsif description.match(/^Presented by (.{5,280}?)\.(.*)/) 
    first = $1
    last = $2
  end
  first.gsub!(/ \(.*?\)(,|$)/, '\1')
  first.gsub!(/\s\s+/, '')
  names = first.split(",").map{|n| n.strip }
  
  return [description, names].flatten
end

def save_speakers(talk, speakers)
  puts talk.summary
  speakers.each{|a| puts a}
  puts

  talk.speaker_talks.each do |speaker|
    if speakers.include?(speaker.name) and speaker.profile
      next
    elsif speakers.include?(speaker.name) and p = Profile.find_by_site_id_and_name(@site.id, speaker.name)
      speaker.profile = p
      speaker.save
    else
      speaker.destroy
    end
  end

  speakers.each do |speaker|
    next unless speaker.match(/\w/)
    next if talk.speaker_talks.map{|a| a.name}.include?(speaker)
    speaker_talk = SpeakerTalk.new
    speaker_talk.talk = talk
    if p = Profile.find_by_site_id_and_name(@site.id, speaker)
      speaker_talk.profile = p
    else
      speaker_talk.name = speaker
    end
    speaker_talk.save
  end
  1+1
end

def update_talk(talk, event)
  result = parse_description(event.description)
  talk.uid = event.uid
  talk.description = result.first
  talk.location = event.location
  talk.start = event.start
  talk.end = event.end 
  talk.save

  save_speakers(talk, result[1..-1])
end

def add_talk(event)
  result = parse_description(event.description)
  talk = Talk.new
  talk.uid = event.uid
  talk.summary = event.summary
  talk.description = result.first
  talk.location = event.location
  talk.start = event.start
  talk.end = event.end 
  talk.conference = @conference
  talk.save

  save_speakers(talk, result[1..-1])
end

@site = Site.find_by_short_name(ARGV[0]) || Site.find_by_short_name("webexsf2008")
@conference = Conference.find_by_site_id(@site.id)
old_conference =  Conference.find_by_name("w2old")
ical_url = ARGV[1]
ical_file = "webexsf2008.ics"
agent = WWW::Mechanize.new
cal = Calendar.new

file = File.open(ical_file)

cal = Icalendar.parse(file).first

existing_talks = {}
@conference.talks.each{|t| existing_talks[t.summary] = "unprocessed"}

cal.events.each do |e|

  if existing_talks[e.summary]
    #puts "Updating #{e.summary}"
    existing_talks[e.summary] = "processed"
    update_talk(Talk.find_by_conference_id_and_summary(@conference.id, e.summary), e)
  else
    #puts "Add talk #{e.summary}"
    add_talk(e)
  end
end

exit
existing_talks.keys.each do |key|
  unless existing_talks[key] == "processed"
  unless existing_talks[key] == "processed"
  puts "Deleting #{key}" 
  talk = Talk.find_by_conference_id_and_summary(@conference.id, key)
  talk.conference = old_conference
  talk.save
  end
  end
end
