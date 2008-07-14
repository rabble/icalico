require File.dirname(__FILE__) + '/../test_helper'

class DayTest < Test::Unit::TestCase
  fixtures :talks
  
  def test_days
    assert days = Day.days
    assert_kind_of Array, days
    assert_equal 2, days.size
  end
  
end
