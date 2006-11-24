require File.dirname(__FILE__) + '/../test_helper'

require 'dns_mock'

class TrackbackTest < Test::Unit::TestCase
  fixtures :contents, :feedback, :blacklist_patterns, :blogs

  def test_permalink_url
    t = feedback(:trackback4)
    assert_equal "http://myblog.net/articles/2004/04/01/second-blog-article#trackback-#{t.id}", t.permalink_url
  end

  def test_edit_url
    t = feedback(:trackback4)
    assert_equal "http://myblog.net/admin/trackbacks/edit/#{t.id}", t.edit_url
  end

  def test_delete_url
    t = feedback(:trackback4)
    assert_equal "http://myblog.net/admin/trackbacks/destroy/#{t.id}", t.delete_url
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
    assert !tb.spam?
  end

  def test_reject_spam_rbl
    tb = Trackback.new do |tb|
      tb.blog_name = "Spammer"
      tb.title = "Spammy trackback"
      tb.excerpt = %{This is just some random text. <a href="http://chinaaircatering.com">without any senses.</a>. Please disregard.}
      tb.url = "http://buy-computer.us"
      tb.ip = "212.42.230.206"
    end

    assert tb.spam?
  end

  def test_reject_spam_pattern
    tb = Trackback.new do |tb|
      tb.blog_name = "Another Spammer"
      tb.title = "Spammy trackback"
      tb.excerpt = "Texas hold-em poker crap"
    end
    assert tb.spam?
  end
end
