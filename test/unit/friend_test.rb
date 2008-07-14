require File.dirname(__FILE__) + '/../test_helper'

class FriendTest < Test::Unit::TestCase
  fixtures :friends, :users
  
  def test_add
    assert users(:jose)
    assert users(:jose).friends
    assert ! users(:jose).friends.include?( users(:arthur) )
    assert users(:jose).friends<< users(:arthur)
    assert users(:jose).friends.include?( users(:arthur) )
  end

  def test_remove
    assert users(:quentin)
    assert users(:quentin).friends
    assert users(:quentin).friends.include?( users(:arthur) )
    assert users(:quentin).friends.delete( users(:arthur) )
    assert ! users(:quentin).friends.include?( users(:arthur) )
  end

end
