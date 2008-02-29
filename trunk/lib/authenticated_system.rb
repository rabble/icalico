module AuthenticatedSystem
  protected
    # Returns true or false if the user is logged in.
    # Preloads @current_user with the user model if they're logged in.
    def logged_in?
      return true unless @current_user.blank?
      return login_from_cookie
    end
    
    # Accesses the current user from the session.
    def current_user
      @current_user if logged_in?
    end
    
    # Store the given user in the session.
    def current_user=(new_user)
      #session[:user] = new_user.nil? ? nil : new_user.id
      @current_user = new_user
    end
    
    # Check if the user is authorized.
    #
    # Override this method in your controllers if you want to restrict access
    # to only a few actions or if you want to check if the user
    # has the correct rights.
    #
    # Example:
    #
    #  # only allow nonbobs
    #  def authorize?
    #    current_user.login != "bob"
    #  end
    def authorized?
       true
    end

    # Filter method to enforce a login requirement.
    #
    # To require logins for all actions, use this in your controllers:
    #
    #   before_filter :login_required
    #
    # To require logins for specific actions, use this in your controllers:
    #
    #   before_filter :login_required, :only => [ :edit, :update ]
    #
    # To skip this in a subclassed controller:
    #
    #   skip_before_filter :login_required
    #
    def login_required
      login_from_cookie
      return true if logged_in?
      
      flash[:notice] = "You need to sign up for an account or login to do that."
      
      redirect_to :controller => 'account', :action => 'login'
      
      false
    end
    
    # Redirect as appropriate when an access request fails.
    #
    # The default action is to redirect to the login screen.
    #
    # Override this method in your controllers if you want to have special
    # behavior in case the user is not authorized
    # to access the requested action.  For example, a popup window might
    # simply close itself.
    def access_denied
      redirect_to :controller => '/account', :action => 'login'
    end  
    
    # Store the URI of the current request in the session.
    #
    # We can return to this location by calling #redirect_back_or_default.
    def store_location
      session[:return_to] = request.request_uri
    end
    
    # Redirect to the URI stored by the most recent store_location call or
    # to the passed default.
    def redirect_back_or_default(default)
      session[:return_to] ? redirect_to_url(session[:return_to]) : redirect_to(default)
      session[:return_to] = nil
    end
    
    # Inclusion hook to make #current_user and #logged_in?
    # available as ActionView helper methods.
    def self.included(base)
      base.send :helper_method, :current_user, :logged_in?
    end

    #
    # When called with before_filter :login_from_cookie will check for an :auth_token
    # cookie and log the user back in if apropriate
    #
    def login_from_cookie
     # logger.warn("login_from_cookie1: #{cookies[:user]}")
      
      return unless cookies[:user]
      
    #  logger.warn("login_from_cookie2: #{cookies[:user]}")
            
      user_name, user_url, external_id, digest = cookies[:user].split(';')
      
      return unless user_name
      
      @current_user = User.find_by_login(user_name) || false
      unless @current_user
        @current_user = User.new(:login => user_name, :url => user_url, :external_id => external_id)
        @current_user.password = 'xxxx'
        @current_user.password_confirmation = 'xxxx'
        @current_user.save
        
        # just for foocamp!  is badness!
        Attendance.create(:conference => conference, :user => @current_user)
        #conference.save
        
      #  logger.warn(@current_user.errors.inspect)
      end
      
      @current_user
    end

end
