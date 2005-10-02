require File.dirname(__FILE__) + '/../test_helper'

class PageTest < Test::Unit::TestCase
  fixtures :contents

  def setup
    @page = Page.find(9)
  end

  def test_validate
    a = Page.new
    a.name = 'a-new-name'
    a.title = 'A Fabulous Page yo!'
    a.body = 'x'

    assert a.save

    b = Page.new
    b.name = a.name
    b.body = a.body
    b.title = a.title

    assert !b.save
  end
end
