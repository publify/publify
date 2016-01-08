require 'rails_helper'

describe "CommentClosing from Test::Unit; no I don't know why it's in article_closing_spec.rb", type: :model do
  def an_article(options = {})
    @blog.articles.create(options.reverse_merge(user_id: 1, body: 'Foo', title: 'Bar'))
  end

  context 'when auto_close setting is zero' do
    before(:each) do
      @blog = FactoryGirl.create(:blog,
                                 sp_article_auto_close: 0,
                                 default_allow_comments: true)
    end

    it 'test_new_article_should_be_open' do
      art = an_article
      art.created_at = Time.now
      assert !art.comments_closed?
    end

    it 'test_old_article_should_be_open' do
      art = an_article(created_at: Time.now - 1000.days)
      assert !art.comments_closed?
    end
  end

  context 'when auto_close setting is nonzero' do
    before(:each) do
      @blog = FactoryGirl.create(:blog,
                                 sp_article_auto_close: 30,
                                 default_allow_comments: true)
    end

    it 'test_new_article_should_be_open' do
      art = an_article
      assert !art.comments_closed?
      art.created_at = Time.now - 29.days
      assert !art.comments_closed?
    end

    it 'test_old_article_should_be_closed' do
      art = an_article(created_at: Time.now - 31.days)
      assert art.comments_closed?
    end
  end
end
