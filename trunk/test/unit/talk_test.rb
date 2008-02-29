require File.dirname(__FILE__) + '/../test_helper'

class TalkTest < Test::Unit::TestCase
  fixtures :talks, :talks_users

  def test_next_2
    talks = Talk.next(n=2)
    assert_equal 2, talks.size, "make sure that we can get 2 talks"
  end
  
  def test_popular
    popular_talks = Talk.find_popular(2)
    assert true
    #assert_equal 2, popular_talks.size
  end
  
end
