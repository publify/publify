require 'rails_helper'

describe Trackback, 'With the various trackback filters loaded and DNS mocked out appropriately', type: :model do
  before(:each) do
    allow(IPSocket).to receive(:getaddress) { raise SocketError.new('getaddrinfo: Name or service not known') }
    FactoryGirl.create(:blog)
    @blog = Blog.default
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
    expect(IPSocket).to receive(:getaddress).with('chinaaircatering.com.bsb.empty.us').at_least(:once).and_return('127.0.0.2')

    tb = Trackback.new(ham_params.merge(excerpt: '<a href="http://chinaaircatering.com">spam</a>'))
    expect(tb).to be_spam
  end

  it 'Trackbacks with a spammy source url should be rejected' do
    add_spam_domain
    tb = Trackback.new(ham_params.merge(url: 'http://www.chinaircatering.com'))
    expect(tb).to be_spam
  end

  it 'Trackbacks from a spammy ip address should be rejected' do
    add_spam_ip('212.42.230.207')
    tb = Trackback.new(ham_params.merge(ip: '212.42.230.207'))
    expect(tb).to be_spam
  end

  def add_spam_domain(domain = 'chinaircatering.com')
    expect(IPSocket).to receive(:getaddress).with("#{domain}.bsb.empty.us").at_least(:once).and_return('127.0.0.2')
  end

  def add_spam_ip(addr = '212.42.230.206')
    rbl_domain = addr.split(/\./).reverse.join('.') + '.opm.blitzed.us'
    expect(IPSocket).to receive(:getaddress).with(rbl_domain).at_least(:once).and_return('127.0.0.2')
  end

  def ham_params
    { blog_name: 'Blog', title: 'trackback', excerpt: 'bland',
      url: 'http://notaspammer.com', ip: '212.42.230.206' }
  end
end
