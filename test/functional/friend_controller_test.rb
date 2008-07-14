require File.dirname(__FILE__) + '/../test_helper'
require 'friend_controller'

# Re-raise errors caught by the controller.
class FriendController; def rescue_action(e) raise e end; end

class FriendControllerTest < Test::Unit::TestCase
  fixtures :users, :friends
  
  def setup
    @controller = FriendController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  
  def test_add
    login_as :jose
    get :add, {:login => users(:quentin).login}
    
    assert_response :redirect
    assert_redirected_to :action => 'index'
    assert users(:jose).friends.include?( users(:quentin) )
  end
  
  def test_remove
    login_as :arthur
    get :remove, {:login => users(:quentin).login}
    
    assert_response :redirect
    assert_redirected_to :action => 'index'
    assert ! users(:arthur).friends.include?( users(:quentin) )
  end
  
  def test_index
    login_as :arthur
    get :index
    
    assert_response :success
    assert assigns(:friends)
    assert_equal users(:arthur).friends, assigns(:friends)
  end
  
  def test_index_other_user
    login_as :arthur
    get :list, {:login => 'quentin'}
    assert_response :success
    assert assigns(:friends)
    assert ! users(:arthur).friends.include?(assigns(:friends))
    assert_equal users(:quentin).friends, assigns(:friends)
  end

end
