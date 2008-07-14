class ListController < ApplicationController
  unloadable
  before_filter :login_required, :only => [ :new, :feedback ]
  before_filter :set_tab

  def set_tab
    @tab = "icalico"
  end
 
  def sub_layout 
    "icalico"
  end  

# it's not fully implimented so i'm commenting thigns out 
  def index
    if current_user
      redirect_to :controller => 'talk', :action => 'list', :login => current_user.name
    else
      redirect_to :controller => 'home', :action => 'index'
    end
  end
  
  def openid
    @user = User.find_by_openid(params[:openid])
    @talks = @user.talks if @user
    render :action => "view"
  end
  
  def view
    if params[:login]
      @user = User.find(current_site)
    elsif params[:id]
      @user = User.find(params[:id])
    end
    return redirect_to(home_url) unless @user
    
    @talks = @user.talks
  end
 
  def feedback
    @user = current_user
    return redirect_to(home_url) unless @user
    
    @talks = @user.talks.find_all{|t| t.start < Time.now or t.start.day == Time.now.day}

    @all_talks = Talk.find_in_order.to_a.find_all{|t| t.start < Time.now || t.start.day == Time.now.day}
  end   
  
#  
#  def new
#   @list = List.new(params[:list])
#   if request.post?
#     if @list.save
#       return redirect_to :action => 'view', :id => @list
#     end
#   end
#  end
     
end
