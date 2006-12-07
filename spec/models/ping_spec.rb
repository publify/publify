require File.dirname(__FILE__) + '/../spec_helper'

context 'Given a post which references a pingback enabled article' do
  fixtures :contents, :blogs

  PINGBACK_TARGET='http://anotherblog.org/xml-rpc'
  REFERENCED_URL='http://anotherblog.org/a-post'
  REFERRER_URL='http://myblog.net/referring-post'


  setup do
    @mock_response = mock('response')
    @mock_xmlrpc_response = mock('xmlrpc_response')
  end

  specify 'Pingback sent to url found in referenced header' do
    @mock_response.should_receive(:[]).with('X-Pingback').at_least(:once).and_return(PINGBACK_TARGET)
    @mock_xmlrpc_response.should_receive(:call).with('pingback.ping', REFERRER_URL, REFERENCED_URL)
    make_and_send_ping
  end

  specify 'Pingback sent to url found in referenced body' do
    @mock_response.should_receive(:[]).with('X-Pingback').at_least(:once).and_return(nil)
    @mock_response.should_receive(:body).at_least(:once)\
      .and_return(%{<link rel="pingback" href="http://anotherblog.org/xml-rpc" />})
    @mock_xmlrpc_response.should_receive(:call).with('pingback.ping', REFERRER_URL, REFERENCED_URL)
    make_and_send_ping
  end

  specify 'Pingback sent when new article is saved' do
    ActiveRecord::Base.observers.should == [:email_notifier, :web_notifier]

    blog = Blog.default

    blog.should_not_send_outbound_pings
    blog.send_outbound_pings = 1
    blog.save!
    blog.should_send_outbound_pings


    a = blog.articles.build \
      :body => '<a href="http://anotherblog.org/a-post">',
      :title => 'Test the pinging',
      :published => true

    Net::HTTP.should_receive(:get_response).and_return(@mock_response)
    XMLRPC::Client.should_receive(:new2).with(PINGBACK_TARGET).and_return(@mock_xmlrpc_response)

    @mock_response.should_receive(:[]).with('X-Pingback').at_least(:once).and_return(PINGBACK_TARGET)
    @mock_xmlrpc_response.should_receive(:call)\
      .with('pingback.ping',
            %r{http://myblog.net/articles/\d{4}/\d{2}/\d{2}/test-the-pinging},
            REFERENCED_URL)


    a.should_have(1).html_urls
    a.save!
    a.should_be_just_published
    a.reload
    a.should_not_be_just_published
    # Saving again will not resend the pings
    a.save
  end

  def make_and_send_ping
    Net::HTTP.should_receive(:get_response).and_return(@mock_response)
    XMLRPC::Client.should_receive(:new2).with(PINGBACK_TARGET).and_return(@mock_xmlrpc_response)

    ping = contents(:article1).pings.build("url" => REFERENCED_URL)
    ping.should_be_instance_of(Ping)
    ping.url.should == REFERENCED_URL
    ping.send_pingback_or_trackback(REFERRER_URL)
  end
end

context "An article links to another article, which contains a trackback URL" do
  fixtures :contents, :blogs

  REFERENCED_URL='http://anotherblog.org/a-post'
  TRACKBACK_URL="http://anotherblog.org/a-post/trackback"
  REFERRER_URL='http://myblog.net/referring-post'

  def expected_trackback_post_data
    "title=Article+1%21&excerpt=body&url=http://myblog.net/referring-post&blog_name=test+blog"
  end

  specify 'Trackback URL is detected and pinged' do
    @mock = mock('html_response')
    Net::HTTP.should_receive(:get_response).with(URI.parse(REFERENCED_URL)).and_return(@mock)
    @mock.should_receive(:[]).with('X-Pingback').at_least(:once)
    @mock.should_receive(:body).twice.and_return(referenced_body)
    Net::HTTP.should_receive(:start).with(URI.parse(TRACKBACK_URL).host, 80).and_yield(@mock)
    @mock.should_receive(:post) \
      .with('/a-post/trackback', expected_trackback_post_data,
            'Content-type' => 'application/x-www-form-urlencoded; charset=utf-8') \
      .and_return(@mock)

    ping = contents(:article1).pings.build(:url => REFERENCED_URL)
    ping.send_pingback_or_trackback(REFERRER_URL)
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

context 'Given a remote site to notify, eg technorati' do
  fixtures :contents, :blogs

  specify 'we can ping them correctly' do
    mock = mock('response')
    XMLRPC::Client.should_receive(:new2).with('http://rpc.technorati.com/rpc/ping').and_return(mock)
    mock.should_receive(:call).with('weblogUpdates.ping', 'test blog',
                                    'http://myblog.net', 'http://myblog.net/new-post')

    ping = contents(:article1).pings.build("url" => "http://rpc.technorati.com/rpc/ping")
    ping.send_weblogupdatesping('http://myblog.net', 'http://myblog.net/new-post')
  end
end
