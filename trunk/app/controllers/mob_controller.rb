class MobController < ApplicationController
  layout 'mobile'
  
  
  def index
  end
  
  def schedule
    @user = User.find_by_login(params[:login])
    if @user
      @talks = @user.upcoming_talks
    else
      @talks = []
    end
  end
  
  def now
    @talks = Talk.next()
  end
  
end
