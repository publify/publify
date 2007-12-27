require File.dirname(__FILE__) + '/../test_helper'

class RedirectTest < Test::Unit::TestCase
  fixtures :redirects

  # Replace this with your real tests.
  def test_exists
    assert_kind_of Redirect, redirects(:foo_redirect)
    assert_kind_of Redirect, redirects(:archive1_redirect)
  end

  def test_uniqueness
    assert_equal redirects(:foo_redirect), Redirect.find_by_from_path('foo/bar')
    redir = Redirect.new
    redir.from_path = 'foo/bar'
    redir.to_path = '/'
    assert !redir.save
  end
end
