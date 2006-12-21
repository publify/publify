require File.dirname(__FILE__) + '/../spec_helper'

context 'With the various trackback filters loaded and DNS mocked out appropriately' do
  setup do
    IPSocket.stub!(:getaddress).and_return { raise SocketError.new("getaddrinfo: Name or service not known") }
  end

  specify 'Incomplete trackbacks should not be accepted' do
    tb = Trackback.new(:blog_name => 'Blog name', :title => 'Title', :excerpt => 'Excerpt')
    tb.should_not_be_valid
    tb.errors.should_be_invalid('url')

    tb.url = 'http://foo.com'
    tb.should_be_valid
    tb.save
    tb.guid.size.should_be > 15
    tb.should_not_be_spam
  end

  specify 'Trackbacks with a spammy link in the excerpt should be rejected' do
    IPSocket.should_receive(:getaddress).with('chinaaircatering.com.bsb.empty.us').at_least(:once).and_return('127.0.0.2')

    tb = Trackback.new(ham_params.merge(:excerpt => '<a href="http://chinaaircatering.com">spam</a>'))
    tb.should_be_spam
  end

  specify 'Trackbacks with a spammy source url should be rejected' do
    add_spam_domain
    tb = Trackback.new(ham_params.merge(:url => 'http://www.chinaircatering.com'))
    tb.should_be_spam
  end

  specify 'Trackbacks from a spammy ip address should be rejected' do
    add_spam_ip('212.42.230.207')
    tb = Trackback.new(ham_params.merge(:ip => '212.42.230.207'))
    tb.should_be_spam
  end

  specify 'Trackbacks with a blacklisted pattern in the excerpt should be rejected' do
    BlacklistPattern.should_receive(:find).with(:all).at_least(:once)\
      .and_return([StringPattern.new(:pattern => 'poker'),
                   RegexPattern.new(:pattern => '^Texas')])
    Trackback.new(ham_params.merge(:excerpt => 'Mmm... come to my shiny poker site')).should_be_spam
    Trackback.new(ham_params.merge(:excerpt => 'Texas hold-em rules!')).should_be_spam
  end

  def add_spam_domain(domain = 'chinaircatering.com')
    IPSocket.should_receive(:getaddress).with("#{domain}.bsb.empty.us").at_least(:once).and_return('127.0.0.2')
  end

  def add_spam_ip(addr = '212.42.230.206')
    rbl_domain = addr.split(/\./).reverse.join('.') + '.opm.blitzed.us'
    IPSocket.should_receive(:getaddress).with(rbl_domain).at_least(:once).and_return('127.0.0.2')
  end

  def ham_params
    { :blog_name => 'Blog', :title => 'trackback', :excerpt => 'bland',
      :url => 'http://notaspammer.com', :ip => '212.42.230.206' }
  end
end
