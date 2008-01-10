require File.dirname(__FILE__) + '/../test_helper'

require 'dns_mock'

class TrackbackTest < Test::Unit::TestCase
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
end
