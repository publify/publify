require File.dirname(__FILE__) + '/../spec_helper'

describe 'Given a post which references a pingback enabled article' do
  def pingback_target; 'http://anotherblog.org/xml-rpc'; end
  def referenced_url; 'http://anotherblog.org/a-post'; end
  def referrer_url; 'http://myblog.net/referring-post'; end


  before(:each) do
    @mock_response = mock('response')
    @mock_xmlrpc_response = mock('xmlrpc_response')
  end

  it 'Pingback sent to url found in referenced header' do
    @mock_response.should_receive(:[]).with('X-Pingback').at_least(:once).and_return(pingback_target)
    @mock_xmlrpc_response.should_receive(:call).with('pingback.ping', referrer_url, referenced_url)
    make_and_send_ping
  end

  it 'Pingback sent to url found in referenced body' do
    @mock_response.should_receive(:[]).with('X-Pingback').at_least(:once).and_return(nil)
    @mock_response.should_receive(:body).at_least(:once)\
      .and_return(%{<link rel="pingback" href="http://anotherblog.org/xml-rpc" />})
    @mock_xmlrpc_response.should_receive(:call).with('pingback.ping', referrer_url, referenced_url)
    make_and_send_ping
  end

  it 'Pingback sent when new article is saved' do
    ActiveRecord::Base.observers.should include(:email_notifier)
    ActiveRecord::Base.observers.should include(:web_notifier)

    blog = Blog.default

    blog.should_not be_send_outbound_pings
    blog.send_outbound_pings = 1
    blog.save!
    blog.should be_send_outbound_pings


    a = Article.new \
      :body => '<a href="http://anotherblog.org/a-post">',
      :title => 'Test the pinging',
      :published => true

    Net::HTTP.should_receive(:get_response).and_return(@mock_response)
    XMLRPC::Client.should_receive(:new2).with(pingback_target).and_return(@mock_xmlrpc_response)

    @mock_response.should_receive(:[]).with('X-Pingback').at_least(:once).and_return(pingback_target)
    @mock_xmlrpc_response.should_receive(:call)\
      .with('pingback.ping',
            %r{http://myblog.net/\d{4}/\d{2}/\d{2}/test-the-pinging},
            referenced_url)


    a.should have(1).html_urls
    a.save!
    a.should be_just_published
    a = Article.find(a.id)
    a.should_not be_just_published
    # Saving again will not resend the pings
    a.save
  end

  def make_and_send_ping
    Net::HTTP.should_receive(:get_response).and_return(@mock_response)
    XMLRPC::Client.should_receive(:new2).with(pingback_target).and_return(@mock_xmlrpc_response)

    ping = contents(:article1).pings.build("url" => referenced_url)
    ping.should be_instance_of(Ping)
    ping.url.should == referenced_url
    ping.send_pingback_or_trackback(referrer_url)
  end
end

describe "An article links to another article, which contains a trackback URL" do
  def referenced_url;  'http://anotherblog.org/a-post'; end
  def trackback_url;  "http://anotherblog.org/a-post/trackback"; end
  def referrer_url;  'http://myblog.net/referring-post'; end

  def expected_trackback_post_data
    "title=Article+1%21&excerpt=body&url=http://myblog.net/referring-post&blog_name=test+blog"
  end

  it 'Trackback URL is detected and pinged' do
    @mock = mock('html_response')
    Net::HTTP.should_receive(:get_response).with(URI.parse(referenced_url)).and_return(@mock)
    @mock.should_receive(:[]).with('X-Pingback').at_least(:once)
    @mock.should_receive(:body).twice.and_return(referenced_body)
    Net::HTTP.should_receive(:start).with(URI.parse(trackback_url).host, 80).and_yield(@mock)
    @mock.should_receive(:post) \
      .with('/a-post/trackback', expected_trackback_post_data,
            'Content-type' => 'application/x-www-form-urlencoded; charset=utf-8') \
      .and_return(@mock)

    ping = contents(:article1).pings.build(:url => referenced_url)
    ping.send_pingback_or_trackback(referrer_url)
  end


  def referenced_body
    <<-eobody
    <rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
           xmlns:trackback="http://madskills.com/public/xml/rss/module/trackback/"
           xmlns:dc="http://purl.org/dc/elements/1.1/">
    <rdf:Description
        rdf:about=""
        trackback:ping="http://anotherblog.org/a-post/trackback"
        dc:title="Track me, track me!"
        dc:identifier="http://anotherblog.org/a-post"
        dc:description="Track me 'til I fart!'"
        dc:creator="pdcawley"
        dc:date="2006-03-01T04:31:00-05:00" />
    </rdf:RDF>
    eobody
  end
end

describe 'Given a remote site to notify, eg technorati' do
  it 'we can ping them correctly' do
    mock = mock('response')
    XMLRPC::Client.should_receive(:new2).with('http://rpc.technorati.com/rpc/ping').and_return(mock)
    mock.should_receive(:call).with('weblogUpdates.ping', 'test blog',
                                    'http://myblog.net', 'http://myblog.net/new-post')

    ping = contents(:article1).pings.build("url" => "http://rpc.technorati.com/rpc/ping")
    ping.send_weblogupdatesping('http://myblog.net', 'http://myblog.net/new-post')
  end
end

describe Ping do

  describe '#send_trackback' do

    it 'should send a trackback without html tag in excerpt' do
      # contents(:xmltest).body = originally seen on <a href="http://blog.rubyonrails.org/">blog.rubyonrails.org</a>
      ping = Ping.new(:article_id => contents(:xmltest).id,
                      :url => 'http://github.com/fdv/typo')

      post = "title=#{CGI.escape("Associations aren't :dependent => true anymore")}"
      post << "&excerpt=#{CGI.escape("originally seen on blog.rubyonrails.org")}" # not original text see if normal ?
      post << "&url=#{contents(:xmltest).permalink_url}"
      post << "&blog_name=#{CGI.escape('test blog')}"

      net_http = mock(Net::HTTP)
      net_http.should_receive(:post).with('/fdv/typo', post,'Content-type' => 'application/x-www-form-urlencoded; charset=utf-8')
      Net::HTTP.should_receive(:start).with('github.com', 80).and_yield(net_http)
      ping.send_trackback('http://github.com/fdv/typo', contents(:xmltest).permalink_url)
    end

    it 'should send a trackback without markdown tag in excerpt' do
      # contents(:markdown_article) #in markdown format\n * we\n * use\n [ok](http://blog.ok.com) to define a link
      ping = Ping.new(:article_id => contents(:markdown_article).id,
                      :url => 'http://github.com/fdv/typo')

      post = "title=#{CGI.escape("How made link with markdown")}"
      post << "&excerpt=#{CGI.escape("in markdown format we use ok to define a link")}" # not original text see if normal ?
      post << "&url=#{contents(:markdown_article).permalink_url}"
      post << "&blog_name=#{CGI.escape('test blog')}"

      net_http = mock(Net::HTTP)
      net_http.should_receive(:post).with('/fdv/typo', post,'Content-type' => 'application/x-www-form-urlencoded; charset=utf-8')
      Net::HTTP.should_receive(:start).with('github.com', 80).and_yield(net_http)
      ping.send_trackback('http://github.com/fdv/typo', contents(:markdown_article).permalink_url)
    end

  end
end
