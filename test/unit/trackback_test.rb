require File.dirname(__FILE__) + '/../test_helper'

require 'dns_mock'

class TrackbackTest < Test::Unit::TestCase
  fixtures :contents, :blacklist_patterns, :settings

  def setup
    config.reload
  end

  def test_incomplete
    tb = Trackback.new
    tb.blog_name = "Blog name"
    tb.title = "Title"
    tb.excerpt = "Excerpt"
    
    assert ! tb.save
    assert tb.errors.invalid?('url')
    
    tb.url = "http://foo.com"
    assert tb.save
    assert tb.errors.empty?
    assert tb.guid.size > 15
  end

  def test_reject_spam_rbl
    tb = Trackback.new
    tb.blog_name = "Spammer"
    tb.title = "Spammy trackback"
    tb.excerpt = %{This is just some random text. <a href="http://chinaaircatering.com">without any senses.</a>. Please disregard.}
    tb.url = "http://buy-computer.us"
    tb.ip = "212.42.230.206"

    assert ! tb.save
    assert tb.errors.invalid?('excerpt')
    assert tb.errors.invalid?('url')
  end
  
  def test_reject_spam_pattern
    tb = Trackback.new
    tb.blog_name = "Another Spammer"
    tb.title = "Spammy trackback"
    tb.excerpt = "Texas hold-em poker crap"
    
    assert ! tb.save
    assert tb.errors.invalid?('excerpt')
  end
end
