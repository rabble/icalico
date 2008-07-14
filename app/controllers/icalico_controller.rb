class IcalicoController < ApplicationController
  unloadable
  #caches_page :index
  before_filter :set_tab

  def set_tab
    @tab = "icalico"
  end

  def sub_layout 
    "icalico"
  end
  
  def index
    @popular_tags = Tag.find_popular(30)
    @popular_speakers = Speaker.find_popular(30)
    
# TODO: 2007-12-10 <tony@tonystubblebine.com> -- Make the start and end date part of the conference record
    day_one = @@conference.talks.sort{|a,b| a.start <=> b.start}.first.start
    @pop_day1 = Talk.find_popular_by_date(day_one.strftime("%Y-%m-%d"), 3)
    @pop_day2 = Talk.find_popular_by_date((day_one + 1.days).strftime("%Y-%m-%d"), 3)
    @pop_day3 = Talk.find_popular_by_date((day_one + 2.days).strftime("%Y-%m-%d"), 3)
  end
  
  def speakers
    @speakers = Speaker.find_popular(300)
  end
  
  def tags
    @tags = Tag.find_popular(300)
  end
  
  def cookieset
#    cookies[:user] = 'quxx;http://foocamp.crowdvine.com/profiles/show/1841;a1bcdef1ghijk1'
    cookies[:user] = "Tony+Stubblebine;http://foocamp.crowdvine.com/profiles/show/1;woot"
  end
end
