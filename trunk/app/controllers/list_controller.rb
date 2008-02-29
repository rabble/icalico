class ListController < ApplicationController
  before_filter :login_required, :only => [ :new ]
 
# it's not fully implimented so i'm commenting thigns out 
  def index
    if current_user
      redirect_to :controller => 'talk', :action => 'list', :login => current_user.login
    else
      redirect_to :controller => 'home', :action => 'index'
    end
  end
  
  def openid
    @user = User.find_by_openid(params[:openid])
    @talks = @user.talks if @user
    render_action :view
  end
  
  def view
    @user = User.find_by_login(params[:login])
    @talks = @user.talks if @user
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
