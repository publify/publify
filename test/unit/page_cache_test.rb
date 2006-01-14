require File.dirname(__FILE__) + '/../test_helper'
require 'page_cache'

class PageCache
  cattr_accessor :deleted_pages
  after_destroy {|page| self.deleted_pages << page.name}
end

class CacheTest < Test::Unit::TestCase
  fixtures :page_caches

  def setup
    PageCache.deleted_pages = Set.new
  end

  # Replace this with your real tests.
  def test_sweep_all
    PageCache.sweep_all
    
    assert_equal(Set.new(['index.html', 'articles/2005/05/05/title']),
                 PageCache.deleted_pages)
  end
  
  def test_sweep_by_pattern
    PageCache.sweep('articles%')

    assert_equal(Set.new(['articles/2005/05/05/title']),
                 PageCache.deleted_pages)
  end
  
end
