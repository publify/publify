require File.dirname(__FILE__) + '/../test_helper'

require 'dns_mock'

class CommentTest < Test::Unit::TestCase
  fixtures :contents, :blacklist_patterns, :text_filters, :blogs

  def test_save_regular
    assert contents(:comment2).save
    assert_equal "http://www.google.com", contents(:comment2).url
  end

  def test_save_spam
    assert contents(:spam_comment).save
    assert_equal "http://fakeurl.com", contents(:spam_comment).url
  end

  def test_create_comment
    c = Comment.new
    c.author = 'Bob'
    c.article_id = 1
    c.body = 'nice post'
    c.ip = '1.2.3.4'

    assert c.save
    assert c.guid.size > 15
  end

  def test_reject_spam_rbl
    c = Comment.new
    c.author = "Spammer"
    c.body = %{This is just some random text. &lt;a href="http://chinaaircatering.com"&gt;without any senses.&lt;/a&gt;. Please disregard.}
    c.url = "http://buy-computer.us"
    c.ip = "212.42.230.206"

    assert ! c.save
    assert c.errors.invalid?('body')
    assert c.errors.invalid?('url')
    assert c.errors.invalid?('ip')
  end

  def test_reject_spam_pattern
    c = Comment.new
    c.author = "Another Spammer"
    c.body = "Texas hold-em poker crap"
    c.url = "http://texas.hold-em.us"

    assert ! c.save
    assert c.errors.invalid?('body')
  end

  def test_reject_spam_uri_limit
    c = Comment.new
    c.author = "Yet Another Spammer"
    c.body = %{ <a href="http://www.one.com/">one</a> <a href="http://www.two.com/">two</a> <a href="http://www.three.com/">three</a> <a href="http://www.four.com/">four</a> }
    c.url = "http://www.uri-limit.com"
    c.ip = "123.123.123.123"

    assert ! c.save
    assert c.errors.invalid?('body')
  end

  def test_reject_article_age
    c = Comment.new
    c.author = "Old Spammer"
    c.body = "Old trackback body"
    c.article = contents(:inactive_article)

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
    assert_equal true, contents(:comment2).has_article?
    assert_equal 1, contents(:comment2).article.id
  end

  def test_xss_rejection
    c = Comment.new
    c.body = "Test foo <script>do_evil();</script>"
    c.author = 'Bob'
    c.article_id = 1

    # Test each filter to make sure that we don't allow scripts through.
    # Yes, this is ugly.
    ['','textile','markdown','smartypants','markdown smartypants'].each do |filter|
      this_blog.comment_text_filter = filter

      assert c.save
      assert c.errors.empty?

      assert c.body_html !~ /<script>/
    end
  end
end
