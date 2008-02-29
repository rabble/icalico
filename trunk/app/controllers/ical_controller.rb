require 'icalendar'
require 'date'
  
class IcalController < ApplicationController
  include Icalendar
  
  def my_schedule
    @user = User.find_by_login(params[:id])
    
    cal = Calendar.new
    
    @user.talks.each do |talk|
      e = Event.new
      e.dtstart =  DateTime.parse(talk.start.xmlschema)
      e.dtend = DateTime.parse(talk.end.xmlschema)
      e.summary = self.ical_escape(talk.summary)
      
      e.description = self.ical_escape(talk.description)
      e.url = talk.url
      e.location = talk.location
      cal.add_event(e)
    end
    cal_string = cal.to_ical
    
    cal_string.gsub!(/SEQ:0/, '')
    cal_string.gsub!(/\\n/, ' ')
    #cal_string.gsub!(/\^\M/, ' ')
    
    send_data(cal_string, 
      :filename => "my-oscon-schedule-#{@user.id}.ics",
      :type => 'text/calendar',
      :disposition => "inline")
  end
  
  def ical_escape(text)
    text.gsub!('<br />', '\n')
    text.gsub!(';', '\;')
    text.gsub!(',', '\,')
    return text
  end
  
  def convert_to_dt(time)
    
  end
  
end
