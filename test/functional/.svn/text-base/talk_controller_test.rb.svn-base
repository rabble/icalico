require File.dirname(__FILE__) + '/../test_helper'
require 'talk_controller'

# Re-raise errors caught by the controller.
class TalkController; def rescue_action(e) raise e end; end

class TalkControllerTest < Test::Unit::TestCase
  fixtures :talks, :users, :lists, :tags
  
  def setup
    @controller = TalkController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_list
    get :list
    assert_response :success
    assert assigns(:talks)
  end
  
  def test_view
    get :view, {:id => talks(:first).id}
    assert_response :success
    assert assigns(:talk)
  end

  def test_add_tag
    login_as :quentin
    post :add_tag, {"tag"=>"java", "commit"=>"Add Tag", "action"=>"add_tag", "id"=>"2", "controller"=>"talk"}
    assert_response :redirect
    assert assigns(:talk), 'did talk get assigned?'
    assert assigns(:talk).tags.include?(Tag.find(:first, :conditions => "name = 'java'"))
    
  end

  def test_remove_tag
    login_as :jose
    post :remove_tag, {"tag"=>"java", "commit"=>"Remove Tag", "action"=>"remove_tag", "id"=>"2", "controller"=>"talk"}
    assert_response :redirect
    assert assigns(:tag)
    assert assigns(:talk)
    assert_equal 'java', assigns(:tag).name
    assert_equal false, assigns(:talk).tags.include?( assigns(:tag))
  end
  
  def test_new
    login_as :arthur
    post :new, {"commit"=>"Add Event", "talk"=>{"end(4i)"=>"09", "end(5i)"=>"34", "start(1i)"=>"2006", 
      "start(2i)"=>"7", "start(3i)"=>"26", "description"=>"test summaryasdfasdf", "summary"=>"test title asdfasdf", 
      "start(4i)"=>"09", "end(1i)"=>"2006", "start(5i)"=>"34", "end(2i)"=>"7", "end(3i)"=>"26"}, 
      "action"=>"new", "controller"=>"talk"}
      
    assert_response :redirect
    assert assigns(:talk)
    assert_equal '2007-07-26', assigns(:talk).start_date
    assert_equal '2007-07-26', assigns(:talk).end_date
    assert_equal '09:34', assigns(:talk).start_time
    assert_equal '09:34', assigns(:talk).end_time
  end
  
  def test_edit
    login_as :quentin
    get :edit, {'id' => talks(:created_talk).id}
    assert_response :success
    assert assigns(:talk)
  end
  
  def test_edit_post
    login_as :quentin
    post :edit, {"talk"=>{"end(4i)"=>"20", "end(5i)"=>"43", "url"=>"", "start(1i)"=>"2007", 
      "start(2i)"=>"4", "start(3i)"=>"16", "description"=>"This is a test even", 
      "summary"=>"test test testasdfasdf", "start(4i)"=>"20", "end(1i)"=>"2007", 
      "start(5i)"=>"43", "end(2i)"=>"4", "end(3i)"=>"16", "location"=>"it will be here"}, 
      "commit"=>"Save New", "action"=>"edit", "id"=>talks(:created_talk).id, "controller"=>"talk"}
    assert_response 302
    assert assigns(:talk)
    assert_equal "You've edited the event!", flash[:notice]
  end
  
  def test_add_chronic
    {"talk"=>{"end_str"=>"midnight", "description"=>"WAREWOLF!!", "summary"=>"Test event", "speakers_str"=>"", "day_str"=>"friday the 22nd", "other_location"=>"", "start_str"=>"9pm", "location"=>"here"}, "commit"=>"Save New", "id"=>""}
    
    assert_response :redirect
    assert assigns(:talk)
    assert_equal "You've added the event!", flash[:notice]
  end
  
end

