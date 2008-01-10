require File.dirname(__FILE__) + "/../spec_helper"

describe "CommentClosing from Test::Unit; no I don't know why it's in article_closing_spec.rb" do
  def an_article(options = {})
    @blog.articles.create(options.reverse_merge(:user_id => 1, :body => 'Foo', :title => 'Bar'))
  end

  before(:each) do
    @blog = blogs(:default)
    @blog.sp_article_auto_close = 0
    @blog.default_allow_comments = true
  end

  def test_new_article_should_be_open_if_auto_close_is_zero
    art = an_article
    art.created_at = Time.now
    assert !art.comments_closed?
  end

  def test_old_article_should_be_open_if_auto_close_is_zero
    art = an_article(:created_at => Time.now - 1000.days)
    assert !art.comments_closed?
  end

  def test_new_article_should_be_open_if_auto_close_is_thirty
    @blog.sp_article_auto_close = 30
    art = an_article
    assert !art.comments_closed?
    art.created_at = Time.now - 29.days
    assert !art.comments_closed?
  end

  def test_old_article_should_be_closed_if_auto_close_is_thirty
    @blog.sp_article_auto_close = 30
    art = an_article(:created_at => Time.now - 31.days)
    assert art.comments_closed?
  end
end
