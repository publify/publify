require File.dirname(__FILE__) + '/../test_helper'

class CacheSupportTest < Test::Unit::TestCase
  fixtures :blogs, :contents, :users, :text_filters, :profiles

  def setup
    @article = Article.find(:first)
  end

  def test_valid_if_unchanged
    assert !@article.invalidates_cache?
  end

  def test_invalidates_if_changed
    @article.body = 'A change of body will smash the cache'
    assert @article.invalidates_cache?
  end

  def test_invalid_if_publication_status_changes
    article = contents(:article1)
    assert ! article.invalidates_cache?
    article.withdraw!
    assert article.invalidates_cache?

    article = contents(:article4)
    article.publish!
    assert article.invalidates_cache?

  end

  def test_valid_if_unpublished_when_destroyed
    a = contents(:article4)
    assert ! a.invalidates_cache?(true)
  end

  def test_invalid_if_newly_unpublished_when_destroyed
    a = contents(:article1)
    a.withdraw!
    assert a.invalidates_cache?(true)
  end

  def test_invalid_if_published_when_destroyed
    a = contents(:article1)
    assert a.invalidates_cache?(true)
  end

  def test_invalid_if_title_changes
    a = contents(:article1)

    a.title = 'A new title'
    assert a.invalidates_cache?
  end

  def test_valid_if_unpublished_and_altered
    a = contents(:article4)

    a.body = 'A new body in just 6 weeks'
    assert ! a.invalidates_cache?
  end
end


