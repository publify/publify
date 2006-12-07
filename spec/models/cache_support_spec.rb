require File.dirname(__FILE__) + '/../spec_helper'

context 'Given a published article' do
  fixtures :blogs, :contents, :feedback, :users, :text_filters

  setup do
    @article = contents(:article1)
  end

  specify "An unchanged article does not invalidate the cache" do
    @article.invalidates_cache?.should_be false
  end

  specify 'changing the body smashes the cache' do
    @article.body = "New Body"
    @article.invalidates_cache?.should_be true
  end

  specify 'withdrawing it smashes the cache' do
    @article.withdraw!
    @article.invalidates_cache?.should_be true
  end

  specify 'destroying it smashes the cache' do
    @article.destroy
    @article.invalidates_cache?(true).should_be true
  end

  specify 'withdrawing, then destroying it smashes the cache' do
    @article.withdraw
    @article.destroy
    @article.invalidates_cache?.should_be true
  end
end

context "Given an unpublished article" do
  fixtures :blogs, :contents, :feedback, :users, :text_filters

  setup { @article = contents(:article4) }

  specify "publishing smashes the cache" do
    @article.publish!
    @article.invalidates_cache?.should_be true
  end

  specify "changing it keeps the cache" do
    @article.body = 'New body'
    @article.invalidates_cache?.should_be false
  end

  specify "destroying it keeps the cache" do
    @article.destroy
    @article.invalidates_cache?.should_be false
  end
end
