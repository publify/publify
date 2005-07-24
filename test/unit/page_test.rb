require File.dirname(__FILE__) + '/../test_helper'

class PageTest < Test::Unit::TestCase
  fixtures :pages

  def setup
    @page = Page.find(1)
  end

  def test_transform
    a = Page.new
    a.name = 'foo'
    a.body = 'abcdabcd'
    assert a.save

    assert a.body_html == a.body
  end

  def test_validate
    a = Page.new
    a.name = 'a-new-name'
    a.body = 'x'
    assert a.save

    b = Page.new
    b.name = a.name
    b.body = a.body

    assert !b.save
  end
end
