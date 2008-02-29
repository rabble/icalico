class TalkController < ApplicationController
  before_filter :login_required, :only => [ :bookmark, :unbookmark, :new, :add_tag, :remove_tag, :new, :edit ]
  #caches_page :talk_view, :view, :by_date, :popular, :list

  verify :params => "id", "flash" => "note",
         :only => [:talk_view, :view, :add_tag, :remove_tag, :bookmark_ajax,
                   :unbookmark_ajax, :bookmark, :unbookmark],
         :add_flash => { "notice" => "The talk id is required." },
         :redirect_to => {:controller => 'talk', :action => 'list'}
  
  before_filter :load_talk_object, :only => [:talk_view, :view, :add_tag, 
                :remove_tag, :bookmark_ajax, :unbookmark_ajax, :bookmark, :unbookmark]
  
  def list
    @talks = Talk.find_in_order
  end
  
  def add
    redirect_to :controller => 'talk', :action => 'new'
  end
  
  def talk_view
  end
  
  def view
    @similar = @talk.methods.include?( 'find_related' ) ?  [] : @talk.find_related
  end
  
  def by_uid
    @talk = Talk.find_by_uid(params[:id])
    @similar = @talk.methods.include?( 'find_related' ) ?  [] : @talk.find_related
    render_action :view
  end
  
  def new
    @talk = current_user.created_talks.build(params[:talk])
    if request.post?
      if @talk.save
        flash[:notice] = "You've added the event!"
        redirect_to :controller => 'talk', :action => 'view', :id => @talk
      end
    end
  end

  def bulk_add
    @talk = current_user.created_talks.build(params[:talk])
    if request.post?
      if @talk.save
        flash[:notice] = "&ldquo;#{@talk.bare_summary}&rdquo; saved."
        return redirect_to :controller => 'talk', :action => 'bulk_add'
      else
        flash[:notice] = "There was an error saving the event."
      end
    end

    render 'talk/new'
  end
  
  def edit
    #@talk = current_user.created_talks.find(params[:id])
    @talk = Talk.find(params[:id])
    return no_permission(params[:id]) unless @talk
    return true unless request.post?

    @talk.attributes=(params[:talk])
    return true unless @talk.save

    flash[:notice] = "You've edited the event!"
    redirect_to :controller => 'talk', :action => 'view', :id => @talk
  end
  
  def delete
    #@talk = current_user.created_talks.find(params[:id])
    @talk = Talk.find(params[:id])
    return no_permission(params[:id]) unless @talk
    @talk.destroy
    
    flash[:notice] = "You've destroyed the event!"
    redirect_to :controller => 'home', :action => 'index'
  end
  
  def by_date
    @talks = Talk.find_by_date(params[:id])
    @page_title = "Talks on #{params[:id]}"
    render_action :list
  end
  
  def by_tag
    @tag = Tag.find_by_name(params[:id]) rescue nil
    redirect_to( home_url ) unless @tag
    
    @talks = Talk.find_by_tag(@tag)
    @page_title = "Talks Tagged: #{@tag.name}"
    render_action :list
  end

  def by_speaker
    @speaker = Speaker.find_by_name(params[:id]) rescue nil
    @talks = Talk.find_by_speaker(@speaker)
    @page_title = "Talks by: #{@speaker.name}"
    render_action :list
  end
  
  def by_location
    @location = params[:location]
    @location.gsub!( /_/, ' ')
    @talks = Talk.find(:all, :conditions => ['location = ?', @location], :order => 'start asc');
    
    @page_title = "Talks in: #{@location}"
    #redirect_to( home_url ) unless @talks
    render_action :list
  end
  
  def by_attendee_list
    @hide_add_remove_link = true
    @attendee_external_ids = params[:ids].split(',').find_all { |v| v.match(/^[0-9]+$/) }.join(', ')
    attendee_talks = Talk.find_by_external_ids(@attendee_external_ids)
    @talks = []
    @talk_attendees = {}
    attendee_talks.each do |talk|
        unless @talk_attendees[talk.id]
          @talks << talk
          @talk_attendees[talk.id] = []
        end
        @talk_attendees[talk.id] << talk.login
    end
    
    callback = params[:callback] ? params[:callback] : 'icalicoMyNetwork'
    text = render_to_string :layout => false
    output = {"text" => text}.to_json
    output = "#{callback}(#{output});"
    render :text => output
  end
  
  def add_tag
    tags_str = params[:tag]
    tags = tags_str.split(' ').collect {|tag_name| tag_name.gsub(/\W+/, '')}
    
    @talk = Talk.find(params[:id]) rescue nil
    
    added = ''
    tags.each do |tag_name| 
      tag = Tag.find_or_create(tag_name) rescue nil
      unless (@talk.tags.include?(tag))
        @talk.tags<< tag
        added << " #{tag.name}"
      end
    end
    flash[:notice] = "Tagged with #{added}." unless added.blank?
    redirect_to :controller => 'talk', :action => 'view', :id => @talk
  end
  
  def remove_tag
    @tag = Tag.find_by_name(params[:tag]) rescue nil
    return redirect_to( :controller => 'talk', :action => 'view', :id => params[:id] ) unless @tag && @talk
    
    @talk.tags.delete( @tag ) if @talk.tags.include?(@tag)
    
    flash[:notice] = "You've removed the #{@tag.name} tag to this event."
    redirect_to :controller => 'talk', :action => 'view', :id => @talk
  end
  
  def popular
    @talks = Talk.find_popular
    @page_title = "Popular Talks"
    render_action :list
  end
  
  def bookmark_ajax
    do_bookmark
    render :partial => 'talk/bookmark_link', :locals => { :talk => @talk }  
  end
  
  def unbookmark_ajax
    do_unbookmark
    render :partial => 'talk/bookmark_link', :locals => { :talk => @talk }  
  end
  
  def bookmark
    do_bookmark
    
    flash[:notice] = "#{@talk.summary} bookmarked."
    
    #redirect_back_or_default :controller => 'talk', :action => 'list'
    expire_page :action => "view", :id => params[:id]
    if request.env['HTTP_REFERER']
      if request.env['HTTP_REFERER'] =~ /bookmark/ or  request.env['HTTP_REFERER'] =~ /account/ 
        redirect_to :controller => 'talk', :action => 'view', :id => params[:id]
      else
        new_link = request.env['HTTP_REFERER']
        new_link.gsub!(/(\#[^\/]*)$/, "\#talk_link_#{@talk.id}")
        redirect_to new_link
      end
    else
      redirect_to :controller => 'talk', :action => 'view', :id => params[:id]
    end
  end
  
  def unbookmark
    do_unbookmark
    
    flash[:notice] = "#{@talk.summary} un-bookmarked."
    #redirect_back_or_default :controller => 'talk', :action => 'list'
    expire_page :action => "view", :id => params[:id]
    if request.env['HTTP_REFERER']
      if request.env['HTTP_REFERER'] =~ /unbookmark/ or  request.env['HTTP_REFERER'] =~ /account/
        redirect_to :controller => 'talk', :action => 'view', :id => params[:id]
      else
        
        if request.env['HTTP_REFERER'] =~ /talk\/list(\#.*)?/
          new_link = request.env['HTTP_REFERER']
          new_link.gsub!(/list(\#.*)$/, "list\#talk_link_#{@talk.id}")
          redirect_to new_link
        else
          redirect_to request.env['HTTP_REFERER']
        end
      end
    else
      redirect_to :controller => 'talk', :action => 'view', :id => params[:id]
    end
  end
  
  private 
  
  def no_permission(talk_id)
    flash[:notice] = "I'm sorry Dave, i can't let you do that. You don't have permission."
    redirect_to :action => 'view', :id => talk_id
  end
  
  def do_bookmark
    current_user.bookmark(@talk)
  end
  
  def do_unbookmark
    current_user.talks.delete(@talk)
  end
  
  def load_talk_object
    @talk = Talk.find(params[:id])
  end
  
  
end
