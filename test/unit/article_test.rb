require File.dirname(__FILE__) + '/../test_helper'

require 'http_mock'

class ArticleTest < Test::Unit::TestCase
  fixtures :blogs, :contents, :articles_tags, :tags, :resources, :categories, :articles_categories, :users, :notifications

  def setup
    @articles = []
  end

  def assert_results_are(*expected)
    assert_equal expected.size, @articles.size
    expected.each do |i|
      assert @articles.include?(i.is_a?(Symbol) ? contents(i) : i)
    end
  end

  def test_create
    a = Article.new
    a.user_id = 1
    a.body = "Foo"
    a.title = "Zzz"
    assert a.save

    a.categories << Category.find(1)
    assert_equal 1, a.categories.size

    b = Article.find(a.id)
    assert_equal 1, b.categories.size
  end

  def test_permalink
    assert_equal contents(:article3), Article.find_by_date(2004,06,01)
    assert_equal [contents(:article2), contents(:article1)], Article.find_all_by_date(2.days.ago.year)
  end

  def test_permalink_with_title
    assert_equal contents(:article3), Article.find_by_permalink(2004, 06, 01, "article-3")
    assert_nil Article.find_by_permalink(2005, 06, 01, "article-5")
  end

  def test_strip_title
    assert_equal "article-3", "Article-3".to_url
    assert_equal "article-3", "Article 3!?#".to_url
    assert_equal "there-is-sex-in-my-violence", "There is Sex in my Violence!".to_url
    assert_equal "article", "-article-".to_url
    assert_equal "lorem-ipsum-dolor-sit-amet-consectetaur-adipisicing-elit", "Lorem ipsum dolor sit amet, consectetaur adipisicing elit".to_url
    assert_equal "my-cats-best-friend", "My Cat's Best Friend".to_url
  end

  def test_perma_title
    assert_equal "article-1", contents(:article1).stripped_title
    assert_equal "article-2", contents(:article2).stripped_title
    assert_equal "article-3", contents(:article3).stripped_title
  end

  def test_html_title
    a = Article.new
    a.title = "This <i>is</i> a <b>test</b>"
    assert a.save

    assert_equal 'this-is-a-test', a.permalink
  end

  def test_urls
    urls = contents(:article4).html_urls
    assert_equal ["http://www.example.com/public"], urls
  end

  ### XXX: Should we have a test here?
  def test_send_pings
  end

  ### XXX: Should we have a test here?
  def test_send_multiple_pings
  end

  def test_tags
    a = Article.new(:title => 'Test tag article',
                    :keywords => 'test tag tag stuff');

    assert_kind_of Article, a
    assert_equal 0, a.tags.size

    a.keywords_to_tags

    assert_equal 3, a.tags.size
    assert_equal ["test", "tag", "stuff"].sort , a.tags.collect {|t| t.name}.sort
    assert a.save

    a.keywords = 'tag bar stuff foo'
    a.keywords_to_tags

    assert_equal 4, a.tags.size
    assert_equal ["foo", "bar", "tag", "stuff"].sort , a.tags.collect {|t| t.name}.sort

    a.keywords='tag bar'
    a.keywords_to_tags

    assert_equal 2, a.tags.size

    a.keywords=''
    a.keywords_to_tags

    assert_equal 0, a.tags.size

    b = Article.new(:title => 'Tag Test 2',
                    :keywords => 'tag test article one two three')

    assert_kind_of Article,b
    assert_equal 0, b.tags.size
  end

  def test_find_published_by_tag_name
    @articles = Tag.find_by_name(tags(:foo_tag).name).articles.find_already_published

    assert_results_are(:article1, :article2)
  end


  def test_find_published
    @articles = Article.find_published
    assert_results_are  :article1, :article2, :article3, :inactive_article

    @articles = Article.find_published(:all,
                                       :conditions => "title = 'Article 1!'")
    assert_results_are :article1
  end

  def test_find_published_by_category
    Article.create!(:title => "News from the future!",
                    :body => "The future is cool!",
                    :keywords => "future",
                    :created_at => Time.now + 12.minutes)

    @articles = Category.find_by_permalink('personal').articles.find_already_published
    assert_results_are :article1, :article2, :article3

    @articles = Category.find_by_permalink('foobar').articles.find_already_published
    assert @articles.empty?

    @articles = Category.find_by_permalink('software').articles.find_already_published
    assert_results_are :article1

    @articles = Category.find_by_permalink('personal').articles.find_already_published(:limit => 1)
    assert_results_are :article2

    @articles = Category.find_by_permalink('personal').articles.find_already_published(:limit => 1, :order => 'created_at ASC')
    assert_results_are :article3
  end

  def test_destroy_file_upload_associations
    assert_equal 2, contents(:article1).resources.size
    contents(:article1).resources << resources(:resource1) << resources(:resource2)
    assert_equal 4, contents(:article1).resources.size
    contents(:article1).destroy
    assert_equal 0, Resource.find(:all, :conditions => "article_id = #{contents(:article1).id}").size
  end

  def test_notifications
    a = Article.new(:title => 'New Article', :body => 'Foo', :author => 'Tobi', :user => users(:tobi))
    assert a.save

    assert_equal 2, a.notify_users.size
    assert_equal ['bob', 'randomuser'], a.notify_users.collect {|u| u.login }.sort
  end

  def test_tags_on_update
    contents(:article3).update_attribute :keywords, "my new tags"
    assert_equal 3, contents(:article3).reload.tags.size
    assert contents(:article3).tags.include?(Tag.find_by_name("new"))
  end

  # this also tests time_delta, indirectly
  def test_find_all_by_date
    feb28 = Article.new
    mar1 = Article.new
    mar2 = Article.new

    feb28.title = "February 28"
    mar1.title = "March 1"
    mar2.title = "March 2"

    feb28.created_at = "2004-02-28"
    mar1.created_at = "2004-03-01"
    mar2.created_at = "2004-03-02"

    [feb28, mar1, mar2].each {|x| x.save }
    assert_equal(1, Article.find_all_by_date(2004,02).size)
    assert_equal(2, Article.find_all_by_date(2004,03).size)
    assert_equal(1, Article.find_all_by_date(2004,03,01).size)

  end
end
