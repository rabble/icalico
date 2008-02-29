require File.dirname(__FILE__) + '/../test_helper'

class TagTest < Test::Unit::TestCase
  fixtures :tags, :talks

  # Replace this with your real tests.
  def test_talk_import
    talk = talks(:first)
    assert tags = Tag.extract_tags(talk.description)

    tags.each do |tag|
      talk.tags<< tag
    end
    
    assert talk.tags
    
  end
  
  def test_search_and_tag
    reload_talks
    assert Tag.search_and_tag('rails')
  end
  
  def reload_talks
    Talk.find_all do |talk|
      talk.save
    end
  end

    
end
