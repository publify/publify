require 'rails_helper'

describe "CommentClosing from Test::Unit; no I don't know why it's in article_closing_spec.rb", type: :model do
  def an_article(options = {})
    Article.create(options.reverse_merge(user_id: 1, body: 'Foo', title: 'Bar'))
  end

  before(:each) do
    @blog = FactoryGirl.create(:blog,
                               sp_article_auto_close: 0,
                               default_allow_comments: true)
    # Blog.default may have already cached a copy of the default blog, and
    # it won't see our changes.  So override the caching.
    allow(Blog).to receive(:default).and_return(@blog)
  end

  it 'test_new_article_should_be_open_if_auto_close_is_zero' do
    art = an_article
    art.created_at = Time.now
    assert !art.comments_closed?
  end

  it 'test_old_article_should_be_open_if_auto_close_is_zero' do
    art = an_article(created_at: Time.now - 1000.days)
    assert !art.comments_closed?
  end

  it 'test_new_article_should_be_open_if_auto_close_is_thirty' do
    @blog.sp_article_auto_close = 30
    art = an_article
    assert !art.comments_closed?
    art.created_at = Time.now - 29.days
    assert !art.comments_closed?
  end

  it 'test_old_article_should_be_closed_if_auto_close_is_thirty' do
    @blog.sp_article_auto_close = 30
    art = an_article(created_at: Time.now - 31.days)
    assert art.comments_closed?
  end
end
