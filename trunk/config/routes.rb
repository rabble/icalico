ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.
  
  # Sample of regular route:
  # map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  # map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # You can have the root of your site routed by hooking up '' 
  # -- just remember to delete public/index.html.
  map.home '', :controller => "home", :action => 'index'
  
  map.connect 'tag/:id', :controller => 'talk', :action => 'by_tag'
  map.connect 'talk/tag/:id', :controller => 'talk', :action => 'by_tag'
  map.connect 'map', :controller => 'home', :action => 'map'
  map.connect 'speakers', :controller => 'home', :action => 'speakers'
  map.connect 'search', :controller => 'search', :action => 'search'
  map.connect 'search/results', :controller => 'search', :action => 'results'
  map.connect 'search/:q', :controller => 'search', :action => 'results' 
  map.connect 'users', :controller => 'account', :action => 'list'
  map.connect 'tags', :controller => 'home', :action => 'tags'
  
  map.connect 'friend/add/:login', :controller => 'friend', :action => 'add'
  map.connect 'friend/remove/:login', :controller => 'friend', :action => 'remove'
  
  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
  map.connect ':controller/service.wsdl', :action => 'wsdl'
  
  map.connect 'list/openid', :controller => 'list', :action => 'openid'
  map.connect 'list/:login', :controller => 'list', :action => 'view'
  
  map.connect 'm', :controller => 'mob', :action => 'index'
  map.connect 'm/:login', :controller => 'mob', :action => 'schedule'
#  map.connect 'mob/:login', :controller => 'mob', :action => 'schedule'
  
  map.connect '/icalico', :controller => 'icalico', :action => 'index'
  
  #map.connect 'list/:id/add/:talk', :controller => 'list', :action => 'add_talk'
  
  map.location 'location/:location', :controller => 'talk', :action => 'by_location'
  map.map_location 'location', :controller => 'home', :action => 'map'
  
  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id'
end

