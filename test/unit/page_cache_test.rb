require File.dirname(__FILE__) + '/../test_helper'
require 'page_cache'

class PageCache

  cattr_accessor :deleted_pages

  def delete_file(path)
    PageCache.deleted_pages << path
  end
end

class CacheTest < Test::Unit::TestCase
  fixtures :page_caches

  def setup
    PageCache.deleted_pages = []
    PageCache.public_path = ''
  end

  # Replace this with your real tests.
  def test_sweep_all
    PageCache.sweep_all

    assert_equal ['/index.html', '/articles/2005/05/05/title'].sort, PageCache.deleted_pages.sort
  end

  def test_sweep_by_pattern
    PageCache.sweep('articles%')

    assert_equal ['/articles/2005/05/05/title'], PageCache.deleted_pages
  end

end
