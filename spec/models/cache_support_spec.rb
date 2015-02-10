require 'rails_helper'

describe 'Given a published article', type: :model do
  before(:each) do
    FactoryGirl.create(:blog)
    FactoryGirl.create(:article)
    @article = Article.first
  end

  it 'An unchanged article does not invalidate the cache' do
    expect(@article).not_to be_invalidates_cache
  end

  it 'changing the body smashes the cache' do
    @article.body = 'New Body'
    expect(@article).to be_invalidates_cache
  end

  it 'withdrawing it smashes the cache' do
    @article.withdraw!
    expect(@article).to be_invalidates_cache
  end

  it 'destroying it smashes the cache' do
    @article.destroy
    expect(@article).to be_invalidates_cache(true)
  end

  it 'withdrawing, then destroying it smashes the cache' do
    @article.withdraw
    @article.destroy
    expect(@article).to be_invalidates_cache
  end
end

describe 'Given an unpublished article', type: :model do
  before(:each) do
    FactoryGirl.create(:blog)
    FactoryGirl.create(:article, published: false, state: 'draft')
    @article = Article.first
  end

  it 'publishing smashes the cache' do
    @article.publish!
    expect(@article).to be_invalidates_cache
  end
  it 'changing it keeps the cache' do
    @article.body = 'New body'
    expect(@article).not_to be_invalidates_cache
  end

  it 'destroying it keeps the cache' do
    @article.destroy
    expect(@article).not_to be_invalidates_cache
  end
end

describe 'Given an unpublished spammy comment', type: :model do
  before(:each) do
    FactoryGirl.create(:blog)
    @comment = FactoryGirl.create(:comment,
                                  published: false,
                                  state: 'presumed_spam',
                                  status_confirmed: false)
  end

  it 'changing it does not alter the cache' do
    @comment.body = 'Lorem ipsum dolor'
    @comment.save
    expect(@comment).not_to be_invalidates_cache
  end

  it 'publishing it does alter the cache' do
    @comment.published = true
    @comment.state = 'presumed_ham'
    @comment.save
    expect(@comment).to be_invalidates_cache
  end

  it 'destroying it does not alter the cache' do
    @comment.destroy
    expect(@comment).not_to be_invalidates_cache
  end
end

describe 'Given a published comment', type: :model do
  before(:each) do
    FactoryGirl.create(:blog)
    @comment = FactoryGirl.create(:comment)
  end

  it 'changing it destroys the cache' do
    @comment.body = 'Lorem ipsum dolor'
    @comment.publish!
    expect(@comment).to be_invalidates_cache
  end

  it 'unpublishing it destroys the cache' do
    @comment.withdraw!
    expect(@comment).to be_invalidates_cache
  end

  it 'destroying it destroys the cache' do
    @comment.destroy
    expect(@comment).to be_invalidates_cache
  end
end

describe 'Given an unpublished spammy trackback', type: :model do
  before(:each) do
    FactoryGirl.create(:blog)
    @trackback = FactoryGirl.create(:trackback, published: false,
                                                state: 'presumed_spam', status_confirmed: false)
  end

  it 'changing it does not alter the cache' do
    @trackback.body = 'Lorem ipsum dolor'
    @trackback.save!
    expect(@trackback).not_to be_invalidates_cache
  end

  it 'publishing it does alter the cache' do
    @trackback.published = true
    @trackback.state = 'presumed_ham'
    @trackback.save!
    expect(@trackback).to be_invalidates_cache
  end

  it 'destroying it does not alter the cache' do
    @trackback.destroy
    expect(@trackback).not_to be_invalidates_cache
  end
end

describe 'Given a published trackback', type: :model do
  before(:each) do
    FactoryGirl.create(:blog)
    @trackback = FactoryGirl.create(:comment)
  end

  it 'changing it destroys the cache' do
    @trackback.body = 'Lorem ipsum dolor'
    @trackback.save
    expect(@trackback).to be_invalidates_cache
  end

  it 'unpublishing it destroys the cache' do
    @trackback.withdraw!
    expect(@trackback).to be_invalidates_cache
  end

  it 'destroying it destroys the cache' do
    @trackback.destroy
    expect(@trackback).to be_invalidates_cache
  end
end
