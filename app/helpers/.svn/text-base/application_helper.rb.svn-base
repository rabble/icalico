 # Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def link_to_add_or_remove_talk(talk, suffix=nil)
    sidebar = 'side' if suffix and suffix.to_s.match(/\w/)
    sidebar ||= ''
    
    if current_user && (current_user.utalks.include?(talk) || sidebar == 'side')
      # remove, or, if we're rendering an invisible one, render it with the remove symbol      
      return(link_to_remove_talk(talk, sidebar) + link_to_add_talk(talk, sidebar, true))
    elsif current_user
      #add
      return(link_to_add_talk(talk, sidebar) + link_to_remove_talk(talk, sidebar, true))
    else
      return link_to(image_tag('add.gif', :border => 0),
        :controller => 'talk', :action => 'bookmark', :id => talk.id)
    end
  end
  
  def link_to_add_talk(talk, sidebar, hidden=false)
    html_options = {
      'title' => 'Add to my schedule', 
      :id => "bookmark_#{sidebar}_#{talk.id}",
      :href=> url_for( :controller => 'talk', :action => 'bookmark', :id => talk.id, :sidebar => sidebar)
    }
    html_options[:style] = "display:none;" if hidden
    
    ajax_options = {
      :url => {:controller => 'talk', :action => 'bookmark_ajax', :id => talk.id, :sidebar => sidebar},
      :update => "bookmark_#{sidebar}_#{talk.id}_span",
      :loading =>  visual_effect(:appear, "ajax_loading_#{sidebar}_gif_#{talk.id}", :duration => 0),
      :success => "new Element.toggle('talk_listing_side_#{talk.id}');"
    }
        
    return link_to_remote( 
      add_gif_image(talk, sidebar) + ajax_loading(talk),
      ajax_options,
      html_options
    )
  end
  
  def link_to_remove_talk(talk, sidebar, hidden=false)
    html_options = {
      'title' => 'Remove from my schedule',
      :id => "unbookmark_#{sidebar}_#{talk.id}",
      :href=> url_for(:controller => 'talk', :action => 'unbookmark', :id => talk.id, :sidebar => sidebar) 
    }
    html_options[:style] = "display:none;" if hidden
    
    success =  "new Element.toggle('talk_listing_side_#{talk.id}');"
    if sidebar == "side"
      success += "new Element.toggle('bookmark__#{talk.id}');"
      success += "new Element.toggle('unbookmark__#{talk.id}');"
    end
    
    ajax_options = { :url =>  {:controller => 'talk', :action => 'unbookmark_ajax', :id => talk.id, :sidebar => sidebar},
    :update => "bookmark_#{sidebar}_#{talk.id}_span",
    :success => success,
    :loading => visual_effect(:appear, "ajax_loading_#{sidebar}_gif_#{talk.id}", :duration => 0)}
    
    return link_to_remote( 
      remove_gif_image(talk, sidebar) + ajax_loading(talk, sidebar) ,
      ajax_options,
      html_options
    )
  end
  
  
    
  
  def link_to_person(person, text='', html_options={})
    text = text.blank? ? person.name : text
    if person.name.match(%r!^http://(.+)!)
      options = {:controller => 'list', :action => 'openid', :openid =>  person.name}
    else
      options = {:controller => 'list', :action => 'view', :login => person.name}
    end
    
    unless current_page?(options)
      link_to(text, options, html_options)
    else
      text
    end
  end
  
  def ajax_loading(talk, sidebar='')
    image_tag('ajax-loader.gif', :border => 0, :class=> 'ajax-loading-hidden', :style=>'display:none;', :id=> "ajax_loading_#{sidebar}_gif_#{talk.id}", :plugin => "icalico")
  end
  
  def add_gif_image(talk, sidebar)
    image_tag('add.gif', :border => 0, :id=> "add_#{sidebar}_gif_#{talk.id}", :plugin => "icalico")
  end
  
  def remove_gif_image(talk, sidebar)
    image_tag('remove.gif', :border => 0, :id=> "remove_#{sidebar}_gif_#{talk.id}", :plugin => "icalico" )
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
