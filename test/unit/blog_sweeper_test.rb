require File.dirname(__FILE__) + '/../test_helper'
ActionController::Base.perform_caching = true

require 'set'
require 'blog_sweeper'

Content.observers = BlogSweeper

class PageCache
  cattr_accessor :deleted_pages
  
  after_destroy {|page| self.deleted_pages << page.name}
end

class BlogSweeperTest < Test::Unit::TestCase
  fixtures :contents, :settings, :articles_tags, :tags, :resources
  fixtures :categories, :articles_categories, :users, :notifications
  
  def setup
    reset_caches
  end

  def reset_caches
    PageCache.delete_all
    PageCache.new(:name => '/index.html',
                  :contributors => [contents(:article3),
                                    contents(:article4),
                                    contents(:article1)]).save!
    PageCache.new(:name => '/articles/2004/06/01/article-3.html',
                  :contributors => contents(:article3).with_responses).save!
    PageCache.new(:name => '/articles/2004/06/01/article-4.html',
                  :contributors => contents(:article4).with_responses).save!
    PageCache.new(:name => '/articles/0000/00/00/article-1.html',
                  :contributors => contents(:article1).with_responses).save!
    PageCache.deleted_pages = Set.new
  end

  def test_update_an_article
    assert art = Article.find(contents(:article4).id)
    art.published = true
    assert art.save

    assert_equal(Set.new(['/index.html', '/articles/2004/06/01/article-4.html']),
                 PageCache.deleted_pages)
  end

  def test_add_a_comment
    a = Article.find(contents(:article1).id)
    c = a.comments.create(:author => 'Bob', :body => 'nice post', :ip => '1.2.3.4')

    assert_deleted('/index.html', '/articles/0000/00/00/article-1.html')
  end

  def test_modify_comment
    c = Article.find(contents(:article1).id).comments.first
    c.body = 'new body'
    c.save!

    assert_deleted('/articles/0000/00/00/article-1.html')
  end

  def assert_deleted(*pages)
    assert_equal(Set.new(pages), PageCache.deleted_pages,
                 "Page Cache is inconsistent")
  end
end
