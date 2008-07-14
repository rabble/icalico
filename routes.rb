
  map.connect 'calendar', :controller => "talk", :action => 'list'
  
  map.connect 'tag/:id', :controller => 'talk', :action => 'by_tag'
  map.connect 'talk/tag/:id', :controller => 'talk', :action => 'by_tag'
  map.connect 'speakers', :controller => 'home', :action => 'speakers'
  map.connect 'tags', :controller => 'home', :action => 'tags'
  
  map.connect 'talks/openid', :controller => 'list', :action => 'openid'
  map.connect 'talks/:login', :controller => 'list', :action => 'view'
  
  map.connect 'mob', :controller => 'mob', :action => 'index'
  map.connect 'mob/:login', :controller => 'mob', :action => 'schedule'
#  map.connect 'mob/:login', :controller => 'mob', :action => 'schedule'
  
  map.connect '/icalico', :controller => 'icalico', :action => 'index'
  
  #map.connect 'list/:id/add/:talk', :controller => 'list', :action => 'add_talk'
  
  map.location 'location/:location', :controller => 'talk', :action => 'by_location'
  
  map.profile_talks 'profiles/:id/talks', :controller => 'list', :action => 'view'
  map.talks_feedback '/feedback', :controller => 'list', :action => 'feedback'

  map.reviews_page 'talk/reviews.:format', :controller => 'talk', :action => 'reviews' 
  map.speaker_ratings 'talk/speaker_ratings.:format', :controller => 'talk', :action => 'speaker_ratings'


