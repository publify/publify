require File.dirname(__FILE__) + "/../spec_helper"

require 'dns_mock'

class CommentTest < Test::Unit::TestCase
  def setup
    CachedModel.cache_reset
  end

  def test_permalink_url
    c = feedback(:old_comment)
    assert_equal "http://myblog.net/articles/2004/05/01/inactive-article#comment-#{c.id}", c.permalink_url
  end

  def test_edit_url
    c = feedback(:old_comment)
    assert_equal "http://myblog.net/admin/comments/edit/#{c.id}", c.edit_url
  end

  def test_delete_url
    c = feedback(:old_comment)
    assert_equal "http://myblog.net/admin/comments/destroy/#{c.id}", c.delete_url
  end

  def test_save_regular
    assert feedback(:comment2).save
    assert_equal "http://www.google.com", feedback(:comment2).url
  end

  def test_save_spam
    assert feedback(:spam_comment).save
    assert_equal "http://fakeurl.com", feedback(:spam_comment).url
  end

  def test_create_comment
    c = Comment.new
    c.author = 'Bob'
    c.article_id = contents(:article1).id
    c.body = 'nice post'
    c.ip = '1.2.3.4'

    assert c.save
    assert c.guid.size > 15
  end

  def test_reject_spam_rbl
    cmt = Comment.new do |c|
      c.author = "Spammer"
      c.body = %{This is just some random text. &lt;a href="http://chinaaircatering.com"&gt;without any senses.&lt;/a&gt;. Please disregard.}
      c.url = "http://buy-computer.us"
      c.ip = "212.42.230.206"
    end
    assert cmt.spam?
    assert !cmt.status_confirmed?
  end

  def test_not_spam_but_rbl_lookup_succeeds
    cmt      = Comment.new do |c|
      c.author = "Not a Spammer"
      c.body   = "Useful commentary!"
      c.url    = "http://www.bofh.org.uk"
      c.ip     = "10.10.10.10"
    end
    assert !cmt.spam?
    assert !cmt.status_confirmed?
  end

  def test_reject_spam_pattern
    cmt = Comment.new do |c|
      c.author = "Another Spammer"
      c.body = "Texas hold-em poker crap"
      c.url = "http://texas.hold-em.us"
    end
    assert cmt.spam?
    assert !cmt.status_confirmed?
  end

  def test_reject_spam_uri_limit
    c = Comment.new do |c|
      c.author = "Yet Another Spammer"
      c.body = %{ <a href="http://www.one.com/">one</a> <a href="http://www.two.com/">two</a> <a href="http://www.three.com/">three</a> <a href="http://www.four.com/">four</a> }
      c.url = "http://www.uri-limit.com"
      c.ip = "123.123.123.123"
    end

    assert c.spam?
    assert !c.status_confirmed?
  end

  def test_reject_article_age
    c = Comment.new do |c|
      c.author = "Old Spammer"
      c.body = "Old trackback body"
      c.article = contents(:inactive_article)
    end

    assert ! c.save
    assert c.errors.invalid?('article_id')

    c.article = @article1

    assert c.save
    assert c.errors.empty?
  end

  def test_modify_old_comment
    c = contents(:inactive_article).comments.first
    c.body = 'Comment body <em>italic</em> <strong>bold</strong>'
    assert c.save
    assert c.errors.empty?
  end

  def test_article_relation
    assert feedback(:comment2).article
    assert_equal contents(:article1), feedback(:comment2).article
  end

  def test_xss_rejection
    c = Comment.new do |c|
      c.body = "Test foo <script>do_evil();</script>"
      c.author = 'Bob'
      c.article_id = contents(:article1).id
    end

    # Test each filter to make sure that we don't allow scripts through.
    # Yes, this is ugly.
    ['','textile','markdown','smartypants','markdown smartypants'].each do |filter|
      this_blog.comment_text_filter = filter

      assert c.save
      assert c.errors.empty?

      assert c.html(:body) !~ /<script>/
    end
  end

  def test_withdraw
    c = Comment.find(feedback(:comment2).id)
    assert c.withdraw!
    assert ! c.published?
    assert c.spam?
    assert c.status_confirmed?
    c.reload
    assert ! c.published?
    assert c.spam?
    assert c.status_confirmed?
  end

  def test_published
    a = Article.new(:title => 'foo', :blog_id => blogs(:default).id)
    assert a.save

    assert_equal 0, a.published_comments.size
    c = a.comments.build(:body => 'foo', :author => 'bob', :published => true, :published_at => Time.now)
    assert c.save
    assert c.published?
    c.reload
    a.reload

    assert_equal 1, a.published_comments.size
    c.withdraw!

    a = Article.new(:title => 'foo', :blog_id => 1)
    assert_equal 0, a.published_comments.size
  end

  def test_status_confirmed
    a = contents(:spammed_article)
    assert !a.comments[0].status_confirmed?
    assert  a.comments[1].status_confirmed?

    a.reload
    assert_equal 1,
      a.comments.find_all_by_status_confirmed(true).size
    assert_equal 1,
      a.comments.find_all_by_status_confirmed(true).size
    a.comments[0].withdraw!
    assert_equal 2,
      a.comments.find_all_by_status_confirmed(true).size
  end

  def test_default_filter
    a = Comment.find(:first)
    assert_equal 'markdown', a.default_text_filter.name
  end
end
