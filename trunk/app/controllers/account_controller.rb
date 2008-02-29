class AccountController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem
  # If you want "remember me" functionality, add the this before_filter uncommended to Application Controller
  before_filter :login_from_cookie
  
  def list
    @users = User.find_active(600)
  end
  
  # say something nice, you goof!  something sweet.
  def index
    redirect_to(:action => 'signup') unless logged_in? || User.count > 0
  end

  def login
    redirect_to "http://foocamp.crowdvine.com/"
    
    # return unless request.post?
    # self.current_user = User.authenticate(params[:login], params[:password])
    # if current_user
    #   if params[:remember_me] == "1"
    #     self.current_user.remember_me
    #     cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
    #   end
    #   
    #   unless @@conference.attendees.include? current_user
    #     @@conference.attendees << current_user
    #   end
    #   
    #   flash[:notice] = "Logged in successfully"
    #   redirect_back_or_default(:controller => '/account', :action => 'index')
    # end
  end

  def signup
    redirect_to "http://foocamp.crowdvine.com/profile/create"
    
    # @user = User.new(params[:user])
    # return unless request.post?
    # if @user.save
    #   #@user.create_list(:name => "#{@user.login}")
    #   @user.remember_me
    #   session[:user] = @user.id
    #   
    #   @@conference.attendees << @user
    #   
    #   flash[:notice] = "Thanks for signing up!"
    #   redirect_back_or_default(:controller => 'talk', :action => 'list')
    # end
  end
  
  def logout
    redirect_to "http://foocamp.crowdvine.com/account/logout"
#    self.current_user.forget_me if logged_in?
#    cookies.delete :auth_token
#    reset_session
#    flash[:notice] = "You have been logged out."
#    redirect_back_or_default(:controller => '/account', :action => 'index')
  end

  # OpenID stuff below

  def openid_start
    return unless request.post?

    openid = params[:openid_identifier]

    openid_request = consumer.begin(openid)

    case openid_request.status
    when OpenID::SUCCESS
      return_to = url_for(:action => 'openid_finish')
      trust_root = url_for(:controller => '')
      server_redirect_url = openid_request.redirect_url(trust_root, return_to)
      redirect_to(server_redirect_url)
      
    when OpenID::FAILURE
      flash[:notice] = "Could not find your OpenID server."
      redirect_back_or_default(:controller => '/account', :action => 'index')
      
    else
      flash[:notice] = "An unknown OpenID error occured."
    end

  end

  def openid_finish
    openid_response = consumer.complete(params)
    
    case openid_response.status
    when OpenID::SUCCESS
      openid = openid_response.identity_url

      @user = User.find_by_openid(openid)
      
      if u = current_user
        if @user
          flash[:notice] = "There is already a user with that OpenID."
        else
          u.openid = openid
          u.save
          flash[:notice] = "OpenID added to account #{openid}"
        end
      else
        unless @user
          @user = User.create(:openid => openid, :login => openid)
        end
        self.current_user = @user
        flash[:notice] = "Welcome #{@user.openid}"  
      end
      
      # not exactly sure where this should take the user after login
      redirect_back_or_default(:controller => 'talk', :action => 'list')
      return
      
    when OpenID::FAILURE
      flash[:notice] = 'Verification failed.'

    when OpenID::CANCEL
      flash[:notice] = 'Verification cancelled.'

    else
      flash[:notice] = 'Unknown response from OpenID server'
    end

  end

  def add_openid
    return unless logged_in?
  end

  private

  def consumer
    store_dir = Pathname.new(RAILS_ROOT).join('db').join('openid-store')
    store = OpenID::FilesystemStore.new(store_dir)
    OpenID::Consumer.new(session, store)
  end

end
