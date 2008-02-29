class FriendController < ApplicationController
  before_filter :login_required
  
  def add
    friend = User.find(:first, :conditions => ['login = ?', params[:login] ] )
    if current_user.friends<< friend
      flash[:notice] = "#{friend.login} has been added to your list of friends."
    else
      flash[:notice] = "Failed to add #{friend.login} as a friend."
    end
    redirect_to :action => 'index'
  end
  
  def remove
    friend = User.find(:first, :conditions => ['login = ?', params[:login] ] )
    
    if current_user.friends.delete( friend )
      flash[:notice] = "#{friend.login} has been removed from your list of friends."
    else
      flash[:notice] = "Failed to remove #{friend.login} as a friend."
    end
    redirect_to :action => 'index'
  end
  
  
  def index
    @friends = current_user.friends
  end
  
  def list
    @user = User.find(:first, :conditions => ['login = ?', params[:login] ] )
    @friends = @user.friends
  end
  
end
