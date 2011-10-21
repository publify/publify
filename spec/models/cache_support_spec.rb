require 'spec_helper'

describe 'Given a published article' do
  before(:each) do
    Factory(:blog)
    Factory(:article)
    @article = Article.first
  end

  it "An unchanged article does not invalidate the cache" do
    @article.should_not be_invalidates_cache
  end

  it 'changing the body smashes the cache' do
    @article.body = "New Body"
    @article.should be_invalidates_cache
  end

  it 'withdrawing it smashes the cache' do
    @article.withdraw!
    @article.should be_invalidates_cache
  end

  it 'destroying it smashes the cache' do
    @article.destroy
    @article.should be_invalidates_cache(true)
  end

  it 'withdrawing, then destroying it smashes the cache' do
    @article.withdraw
    @article.destroy
    @article.should be_invalidates_cache
  end
end

describe "Given an unpublished article" do
  before(:each) do
    Factory(:blog)
    Factory(:article, :published => false, :state => 'draft')
    @article = Article.first
  end

  it "publishing smashes the cache" do
    @article.publish!
    @article.should be_invalidates_cache
  end
  it "changing it keeps the cache" do
    @article.body = 'New body'
    @article.should_not be_invalidates_cache
  end

  it "destroying it keeps the cache" do
    @article.destroy
    @article.should_not be_invalidates_cache
  end
end

describe "Given an unpublished spammy comment" do
  before(:each) do
    Factory(:blog)
    @comment = Factory(:comment, 
        :published => false,
        :state => 'presumed_spam',
        :status_confirmed => false)
  end

  it 'changing it does not alter the cache' do
    @comment.body = "Lorem ipsum dolor"
    @comment.save
    @comment.should_not be_invalidates_cache
  end

  it 'publishing it does alter the cache' do
    @comment.published = true
    @comment.state = 'presumed_ham'
    @comment.save
    @comment.should be_invalidates_cache
  end

  it 'destroying it does not alter the cache' do
    @comment.destroy
    @comment.should_not be_invalidates_cache
  end
end

describe "Given a published comment" do
  before(:each) do
    Factory(:blog)
    @comment = Factory(:comment)
  end

  it 'changing it destroys the cache' do
    @comment.body = "Lorem ipsum dolor"
    @comment.publish!
    @comment.should be_invalidates_cache
  end

  it 'unpublishing it destroys the cache' do
    @comment.withdraw!
    @comment.should be_invalidates_cache
  end

  it 'destroying it destroys the cache' do
    @comment.destroy
    @comment.should be_invalidates_cache
  end
end

describe "Given an unpublished spammy trackback" do
  before(:each) do
    Factory(:blog)
    @trackback = Factory(:trackback, :published => false,
      :state => 'presumed_spam', :status_confirmed => false)
  end

  it 'changing it does not alter the cache' do
    @trackback.body = "Lorem ipsum dolor"
    @trackback.save!
    @trackback.should_not be_invalidates_cache
  end

  it 'publishing it does alter the cache' do
    @trackback.published = true
    @trackback.state = 'presumed_ham'
    @trackback.save!
    @trackback.should be_invalidates_cache
  end

  it 'destroying it does not alter the cache' do
    @trackback.destroy
    @trackback.should_not be_invalidates_cache
  end
end

describe "Given a published trackback" do
  before(:each) do
    Factory(:blog)
    @trackback = Factory(:comment)
  end

  it 'changing it destroys the cache' do
    @trackback.body = "Lorem ipsum dolor"
    @trackback.save
    @trackback.should be_invalidates_cache
  end

  it 'unpublishing it destroys the cache' do
    @trackback.withdraw!
    @trackback.should be_invalidates_cache
  end

  it 'destroying it destroys the cache' do
    @trackback.destroy
    @trackback.should be_invalidates_cache
  end
end
