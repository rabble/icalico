require File.dirname(__FILE__) + '/../test_helper'
require 'icalico_controller'

# Re-raise errors caught by the controller.
class IcalicoController; def rescue_action(e) raise e end; end

class IcalicoControllerTest < Test::Unit::TestCase
  def setup
    @controller = IcalicoController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
