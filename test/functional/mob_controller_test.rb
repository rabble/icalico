require File.dirname(__FILE__) + '/../test_helper'
require 'mob_controller'

# Re-raise errors caught by the controller.
class MobController; def rescue_action(e) raise e end; end

class MobControllerTest < Test::Unit::TestCase
  def setup
    @controller = MobController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
