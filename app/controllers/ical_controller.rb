require 'icalendar'
require 'date'
  
class IcalController < ApplicationController
  unloadable
  include Icalendar
  before_filter :set_tab

  def set_tab
    @tab = "icalico"
  end

  def sub_layout 
    "icalico"
  end  

  def my_schedule
    @user = User.find(params[:id])
   
    return render_error(404) unless @user

    cal = Calendar.new
    if current_site.short_name == "webexsf2008"
      cal.timezone do |t| 
        t.tzid = "US/Pacific"
        t.tzoffsetfrom = "-0700"
        t.tzoffsetto = "-0800"
      
        s = Standard.new
        t.tzoffsetfrom = "-0700"
        t.tzoffsetto = "-0800"
        t.dtstart = "19621028T020000"
        # t.rrule = "FREQ=YEARLY;UNTIL=20061029T090000Z;BYMONTH=10;BYDAY=-1SU"
        t.tzname = "PST"
        
        t.add_component(s)
      
        d = Daylight.new
        d.tzoffsetfrom = "-0700"
        d.tzoffsetto = "-0800"
        d.dtstart = "20070311T020000"
        # d.rrule = "FREQ=YEARLY;BYMONTH=3;BYDAY=2SU"
        t.tzname = "PST"
      
        t.add_component(d)
        
        s = Standard.new
        t.tzoffsetfrom = "-0700"
        t.tzoffsetto = "-0800"
        t.dtstart = "20071104T020000"
        # t.rrule = "FREQ=YEARLY;BYMONTH=11;BYDAY=1SU"
        t.tzname = "PST"
      
        t.add_component(s)
      end
    end

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
      :filename => "my-#{current_site.short_name}-schedule-#{@user.id}.ics",
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
