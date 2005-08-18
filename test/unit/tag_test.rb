require File.dirname(__FILE__) + '/../test_helper'

class TagTest < Test::Unit::TestCase
  fixtures :tags, :articles, :articles_tags

  def setup
    @tag = Tag.find(1)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of Tag,  @tag
  end

  def test_get
    tag=Tag.get('foo')
    assert @foo_tag==tag

    tag2=Tag.get('zzz')
    assert_kind_of Tag, tag2
    assert 3, tag2.id
    assert 'zzz', tag2.name
  end

  def test_uniqueness
    tag1=Tag.create(:name => 'test')
    assert_kind_of Tag, tag1
    assert 'test', tag1.name

    tag2=Tag.new(:name => 'test')
    assert_kind_of Tag, tag2
    assert 'test', tag2.name

    assert tag1 != tag2

    assert ! tag2.save
    assert tag2.errors.invalid?('name')
  end

  def test_article
    a1=Article.create(:title => 'Article 1')
    assert_kind_of Article, a1
    a1.tags << @foo_tag
    a1.tags << @bar_tag

    assert a1.tags.size == 2
    assert a1.tags.sort_by {|i| i.id} == [@foo_tag,@bar_tag].sort_by {|i| i.id}
  end

  def test_find_all_with_article_counters
    tags=Tag.find_all_with_article_counters

    assert 2, tags.size
    assert "bar", tags.first.name
    assert 1, tags.first.article_counter

    assert "foo", tags.last.name
    assert 2, tags.last.article_counter
  end
end
