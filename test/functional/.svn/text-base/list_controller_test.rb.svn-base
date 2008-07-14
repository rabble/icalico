require File.dirname(__FILE__) + '/../test_helper'
require 'list_controller'

# Re-raise errors caught by the controller.
class ListController; def rescue_action(e) raise e end; end

class ListControllerTest < Test::Unit::TestCase
  include ApplicationHelper
  
  fixtures :talks, :users, :lists

  def setup
    @controller = ListController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  
  def test_index
    get :index
    assert_response :redirect
  end
  
  def test_view
    get :view, {:login => users(:arthur).login}
    #assert_response :success
    #assert assigns(:list)
  end
  
#  def test_new_get
#    current_user= users(:quentin)
#    get :new
#    assert_response :success
#    assert assigns(:list)
#  end
#  
#  def test_new_post
#    current_user= users(:quentin)
#    post :new
#    assert_response :success
#  end
#
#
#  def test_link_to_add_or_remove_talk
#    assert link_to_add_or_remove_talk(talks(:first))
#  end

end

