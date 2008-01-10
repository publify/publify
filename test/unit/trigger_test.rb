require File.dirname(__FILE__) + '/../test_helper'
require 'page'
class Page
  def tickle
    self.body = "I got tickled!"
    self.save!
  end
end

class TriggerTest < Test::Unit::TestCase
  def test_post_action
    assert Trigger.post_action(Time.now + 2.seconds,
                               contents(:first_page),
                               'tickle')
    assert_equal "ho ho ho", Page.find(contents(:first_page).id).body
    sleep 3
    assert Trigger.fire
    assert_equal 0, Trigger.count
    assert_equal "I got tickled!", Page.find(contents(:first_page).id).body
  end

  def test_post_immediate_action
    assert Trigger.post_action(Time.now,
                               contents(:first_page),
                               'tickle')
    assert_equal "I got tickled!", Page.find(contents(:first_page).id).body
    assert_equal 0, Trigger.count
  end

  def test_post_future_action
    assert Trigger.post_action(Time.now + 1.hour,
                               contents(:first_page),
                               'tickle')
    assert_equal "ho ho ho", Page.find(contents(:first_page).id).body
    assert_equal 1, Trigger.count
  end

end
