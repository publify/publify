require File.dirname(__FILE__) + '/../test_helper'

class TagTest < Test::Unit::TestCase
  fixtures :tags, :contents, :articles_tags, :blogs

  def setup
    @tag = Tag.find(1)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of Tag,  @tag
  end

  def test_get
    tag=Tag.get('foo')
    assert_equal tags(:foo_tag), tag

    tag2=Tag.get('zzz')
    assert_kind_of Tag, tag2
    #assert_equal 3, tag2.id # this conflicts with MySQL's auto_increment
    assert_equal 'zzz', tag2.name
  end

  def test_uniqueness
    tag1 = Tag.create(:name => 'test')
    assert_kind_of Tag, tag1
    assert_equal 'test', tag1.name

    tag2 = Tag.new(:name => 'test')
    assert_kind_of Tag, tag2
    assert_equal 'test', tag2.name

    assert_not_equal tag1, tag2

    assert ! tag2.save, "Duplicate tag save did not fail"
    assert tag2.errors.invalid?('name'), "name field did not have error"

    tag3 = Tag.create(:name => 'Monty Python')
    assert_kind_of Tag, tag3
    assert_equal 'montypython', tag3.name
    assert_equal 'Monty Python', tag3.display_name
  end

  def test_article
    a1=Article.create(:title => 'Article 1')
    assert_kind_of Article, a1
    a1.tags << tags(:foo_tag)
    a1.tags << tags(:bar_tag)

    assert_equal 2, a1.tags.size
    assert_equal [tags(:foo_tag),tags(:bar_tag)].sort_by {|i| i.id}, a1.tags.sort_by {|i| i.id}
  end

  def test_find_all_with_article_counters
    tags=Tag.find_all_with_article_counters(10)

    assert_equal 2, tags.size

    assert_equal "foo", tags.first.name
    assert_equal 1, tags.last.article_counter

    assert_equal "bar", tags.last.name
    assert_equal 2, tags.first.article_counter
  end
  
  def test_permalink
    tag = Tag.get('foo')
    assert_equal 'http://myblog.net/articles/tag/foo', tag.permalink_url
  end
end
