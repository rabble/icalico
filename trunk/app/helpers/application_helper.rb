# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def link_to_add_or_remove_talk(talk, suffix=nil)
    sidebar = 'side' if suffix
    sidebar ||= ''
    if current_user && current_user.talks.include?( talk)
      
      #remove
      return link_to_remote( 
          remove_gif_image(talk, sidebar) + ajax_loading(talk, sidebar) ,
        { :url =>  {:controller => 'talk', :action => 'unbookmark_ajax', :id => talk.id},
          :update => "unbookmark_#{sidebar}_#{talk.id}", 
          :loading => visual_effect(:appear, "ajax_loading_#{sidebar}_gif_#{talk.id}", :duration => 0)},
        {'title' => 'Remove from my schedule', :id => "unbookmark_#{sidebar}_#{talk.id}",
         :href=> url_for( :controller => 'talk', :action => 'unbookmark', :id => talk.id) } )
    elsif current_user
      
      #add
      return link_to_remote( add_gif_image(talk) + ajax_loading(talk),
          {:url => {:controller => 'talk', :action => 'bookmark_ajax', :id => talk.id},
          :update => "bookmark_#{talk.id}", 
          :loading =>  visual_effect(:appear, "ajax_loading__gif_#{talk.id}", :duration => 0)},
          {'title' => 'Add to my schedule', :id => "bookmark_#{talk.id}",
          :href=> url_for( :controller => 'talk', :action => 'bookmark', :id => talk.id) })     
    else
      return link_to(image_tag('add.gif', :border => 0),
        :controller => 'talk', :action => 'bookmark', :id => talk.id)
    end
  end
  
  def link_to_person(person, text='', html_options={})
    text = text.blank? ? person.login : text
    if person.login.match(%r!^http://(.+)!)
      options = {:controller => 'list', :action => 'openid', :openid =>  person.login}
    else
      options = {:controller => 'list', :action => 'view', :login => person.login}
    end
    
    unless current_page?(options)
      link_to(text, options, html_options)
    else
      text
    end
  end
  
  def ajax_loading(talk, sidebar='')
    image_tag('ajax-loader.gif', :border => 0, :class=> 'ajax-loading-hidden', :style=>'display:none;', :id=> "ajax_loading_#{sidebar}_gif_#{talk.id}")
  end
  
  def add_gif_image(talk)
    image_tag('add.gif', :border => 0, :id=> "add_gif_#{talk.id}")
  end
  
  def remove_gif_image(talk, sidebar)
    image_tag('remove.gif', :border => 0, :id=> "remove_#{sidebar}_gif_#{talk.id}" )
  end
  
  #, :before => image_tag('ajax-loading.gif', :border => 0) 
  # :loading => visual_effect(:appear, "ajax-loading-hidden", :duration => 2.5)
  #   :loading => visual_effect(:appear, "ajax-loading-hidden", :duration => 2.5)
#  update_element_function(
#          "cart", :action => :update, :position => :bottom,
#          :content => "<p>New Product: #{@product.name}</p>"))
  
  # link_to_remote( "click here", :update => "time_div", :url =>{ :action => :say_when })
  
  
  def popularity_rank(pop, n=2)
    lower = pop.to_i / n
    lower = 10 if lower > 10
    lower = 1 if lower < 1
    return lower
  end
  
  def space_to_underscore(string)
    return string.gsub(/\s/, '_')
  end
  
  def display_flash_notice
    
    return '' unless flash[:notice]
    return  '<div class="notice"><p class="notice">' + flash[:notice].to_s + '</p></div>'
  end
  
  def detag(string)
    return string.gsub(/_/, ' ')
  end
end
