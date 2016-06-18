require 'rails_helper'
require 'support/dns_mock'

describe Trackback, 'With the various trackback filters loaded and DNS mocked out appropriately', type: :model do
  let(:article) { create(:article) }

  before(:each) do
    @blog = FactoryGirl.create(:blog)
    @blog.sp_global = true
    @blog.default_moderate_comments = false
    @blog.save!
  end

  it 'Incomplete trackbacks should not be accepted' do
    tb = Trackback.new(blog_name: 'Blog name',
                       title: 'Title',
                       excerpt: 'Excerpt',
                       article_id: FactoryGirl.create(:article).id)
    expect(tb).not_to be_valid
    expect(tb.errors['url']).to be_any
  end

  it 'A valid trackback should be accepted' do
    tb = Trackback.new(blog_name: 'Blog name',
                       title: 'Title',
                       url: 'http://foo.com',
                       excerpt: 'Excerpt',
                       article_id: FactoryGirl.create(:article).id)
    expect(tb).to be_valid
    tb.save
    expect(tb.guid.size).to be > 15
    expect(tb).not_to be_spam
  end

  it 'Trackbacks with a spammy link in the excerpt should be rejected' do
    tb = article.trackbacks.build(ham_params.merge(excerpt: '<a href="http://chinaaircatering.com">spam</a>'))
    expect(tb).to be_spam
  end

  it 'Trackbacks with a spammy source url should be rejected' do
    tb = article.trackbacks.build(ham_params.merge(url: 'http://www.chinaircatering.com'))
    expect(tb).to be_spam
  end

  it 'Trackbacks from a spammy ip address should be rejected' do
    tb = article.trackbacks.build(ham_params.merge(ip: '212.42.230.207'))
    expect(tb).to be_spam
  end

  def ham_params
    { blog_name: 'Blog', title: 'trackback', excerpt: 'bland',
      url: 'http://notaspammer.com', ip: '212.42.230.206' }
  end
end
