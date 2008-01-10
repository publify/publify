require File.dirname(__FILE__) + '/../spec_helper'

describe 'Given a published article' do
  before(:each) do
    @article = contents(:article1)
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
  before(:each) { @article = contents(:article4) }

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
