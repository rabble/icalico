require File.dirname(__FILE__) + '/../test_helper'
require 'search_controller'

# Re-raise errors caught by the controller.
class SearchController; def rescue_action(e) raise e end; end

class SearchControllerTest < Test::Unit::TestCase
  def setup
    @controller = SearchController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_search
    reload_talks
    get :results, {"commit"=>"Go", "action"=>"results", "q"=>"ruby", "controller"=>"search"}
    assert_response :success
  end
  
  def reload_talks
    Talk.find_all do |talk|
      talk.save
    end
  end
end
