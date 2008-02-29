# Filters added to this controller will be run for all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  attr_accessor :conference
  @@conference = nil
  before_filter :load_conference

  protected
    def load_conference
      @@conference = Conference.find_by_subdomain(subdomain)
      raise "No conference found for #{subdomain}" unless @@conference
      ActiveRecord::Base.conference = @@conference
      conference = @@conference
      
      return( redirect_to_about_page ) if @@conference.nil?
    end
    
    def redirect_to_about_page
      redirect_to( :controller => 'icalico', :action => 'index' ) unless @controller == 'icalico'
    end
    
    def subdomain
      request.subdomains.first || request.domain.split('.').first
    end
end
