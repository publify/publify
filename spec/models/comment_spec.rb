require File.dirname(__FILE__) + "/../spec_helper"

require 'dns_mock'

describe Comment do
  before(:each) do
    CachedModel.cache_reset
  end

  describe 'save' do
    it 'should not save with article not allow comment'
  end

  describe '#permalink_url' do
    it 'should render permalink to comment in public part' do
      c = feedback(:old_comment)
      assert_equal "http://myblog.net/2004/05/01/inactive-article#comment-#{c.id}", c.permalink_url
    end
  end

  describe '#edit_url' do
    it 'should get a url where edit comment in admin' do
      c = feedback(:old_comment)
      assert_equal "http://myblog.net/admin/comments/edit/#{c.id}", c.edit_url
    end
  end

  describe '#delete_url' do
    it 'should get the delete url of comment in admin part' do
      c = feedback(:old_comment)
      assert_equal "http://myblog.net/admin/comments/destroy/#{c.id}", c.delete_url
    end
  end

  describe '#save' do
    it 'should save good comment' do
      assert feedback(:comment2).save
      assert_equal "http://www.google.com", feedback(:comment2).url
    end

    it 'should save spam comment' do
      assert feedback(:spam_comment).save
      assert_equal "http://fakeurl.com", feedback(:spam_comment).url
    end

    it 'should not save in invalid article' do
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

    it 'should change old comment' do
      c = contents(:inactive_article).comments.first
      c.body = 'Comment body <em>italic</em> <strong>bold</strong>'
      assert c.save
      assert c.errors.empty?
    end

  end

  describe '#create' do

    it 'should create comment' do
      c = Comment.new
      c.author = 'Bob'
      c.article_id = contents(:article1).id
      c.body = 'nice post'
      c.ip = '1.2.3.4'

      assert c.save
      assert c.guid.size > 15
    end

  end

  describe '#spam?' do
    it 'should reject spam rbl' do
      cmt = Comment.new do |c|
        c.author = "Spammer"
        c.body = %{This is just some random text. &lt;a href="http://chinaaircatering.com"&gt;without any senses.&lt;/a&gt;. Please disregard.}
        c.url = "http://buy-computer.us"
        c.ip = "212.42.230.206"
      end
      assert cmt.spam?
      assert !cmt.status_confirmed?
    end

    it 'should not define spam a comment rbl with lookup succeeds' do
      cmt      = Comment.new do |c|
        c.author = "Not a Spammer"
        c.body   = "Useful commentary!"
        c.url    = "http://www.bofh.org.uk"
        c.ip     = "10.10.10.10"
      end
      assert !cmt.spam?
      assert !cmt.status_confirmed?
    end

    it 'should reject spam pattern' do
      cmt = Comment.new do |c|
        c.author = "Another Spammer"
        c.body = "Texas hold-em poker crap"
        c.url = "http://texas.hold-em.us"
      end
      assert cmt.spam?
      assert !cmt.status_confirmed?
    end

    it 'should reject spam with uri limit' do
      c = Comment.new do |c|
        c.author = "Yet Another Spammer"
        c.body = %{ <a href="http://www.one.com/">one</a> <a href="http://www.two.com/">two</a> <a href="http://www.three.com/">three</a> <a href="http://www.four.com/">four</a> }
        c.url = "http://www.uri-limit.com"
        c.ip = "123.123.123.123"
      end

      assert c.spam?
      assert !c.status_confirmed?
    end

  end

  it 'should have good relation' do
    assert feedback(:comment2).article
    assert_equal contents(:article1), feedback(:comment2).article
  end

  describe 'reject xss' do
    before(:each) do
      @comment = Comment.new do |c|
        c.body = "Test foo <script>do_evil();</script>"
        c.author = 'Bob'
        c.article_id = contents(:article1).id
      end
    end
    ['','textile','markdown','smartypants','markdown smartypants'].each do |filter|
      it "should reject with filter #{filter}" do
        Blog.default.comment_text_filter = filter

        assert @comment.save
        assert @comment.errors.empty?

        assert @comment.html(:body) !~ /<script>/
      end
    end
  end

  describe 'change state' do
    it 'should becomes withdraw' do
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

    it 'should becomes not published in article if withdraw' do
      a = Article.new(:title => 'foo')
      assert a.save

      assert_equal 0, a.published_comments.size
      c = a.comments.build(:body => 'foo', :author => 'bob', :published => true, :published_at => Time.now)
      assert c.save
      assert c.published?
      c.reload
      a.reload

      assert_equal 1, a.published_comments.size
      c.withdraw!

      a = Article.new(:title => 'foo')
      assert_equal 0, a.published_comments.size
    end

    it 'should becomes not confirmed in article if withdraw' do
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
  end

  it 'should have good default filter' do
    a = Comment.find(:first)
    assert_equal 'markdown', a.default_text_filter.name
  end

end
