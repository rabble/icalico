class HomeController < ApplicationController
  #caches_page :index
  
  def index
    @popular_tags = Tag.find_popular(30)
    @popular_speakers = Speaker.find_popular(30)
    
    @pop_day1 = Talk.find_popular_by_date('2007-06-22', 3)
    @pop_day2 = Talk.find_popular_by_date('2007-06-23', 3)
    @pop_day3 = Talk.find_popular_by_date('2007-06-24', 3)
    
    @random_people = User.find_random(30)
    
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
