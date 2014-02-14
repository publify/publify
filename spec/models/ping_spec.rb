require 'spec_helper'
require 'xmlrpc/client'

describe :ping do
  describe 'Given a post which references a pingback enabled article' do

    let(:pingback_target) { 'http://anotherblog.org/xml-rpc' }
    let(:referenced_url) { 'http://anotherblog.org/a-post' }
    let(:referrer_url) { 'http://myblog.net/referring-post' }
    let(:mock_response) { double('response') }
    let(:mock_xmlrpc_response) { double('xmlrpc_response') }

    context "with a default blog" do
      let!(:blog) { create(:blog) }

      it 'Pingback sent to url found in referenced header' do
        mock_response.should_receive(:[]).with('X-Pingback').at_least(:once).and_return(pingback_target)
        mock_xmlrpc_response.should_receive(:call).with('pingback.ping', referrer_url, referenced_url)
        make_and_send_ping
      end

      it 'Pingback sent to url found in referenced body' do
        mock_response.should_receive(:[]).with('X-Pingback').at_least(:once).and_return(nil)
        mock_response.should_receive(:body).at_least(:once)\
          .and_return(%{<link rel="pingback" href="http://anotherblog.org/xml-rpc" />})
        mock_xmlrpc_response.should_receive(:call).with('pingback.ping', referrer_url, referenced_url)
        make_and_send_ping
      end
    end

    context "with a send outbound pings blog" do
      let!(:blog) { create(:blog, send_outbound_pings: 1) }

      it 'Pingback sent when new article is saved' do
        ActiveRecord::Base.observers.should include(:email_notifier)
        ActiveRecord::Base.observers.should include(:web_notifier)
        a = Article.new :body => '<a href="http://anotherblog.org/a-post">', :title => 'Test the pinging', :published => true

        Net::HTTP.should_receive(:get_response).and_return(mock_response)
        XMLRPC::Client.should_receive(:new2).with(pingback_target).and_return(mock_xmlrpc_response)

        mock_response.should_receive(:[]).with('X-Pingback').at_least(:once).and_return(pingback_target)
        mock_xmlrpc_response.should_receive(:call).with('pingback.ping', %r{http://myblog.net/\d{4}/\d{2}/\d{2}/test-the-pinging}, referenced_url)

        a.should have(1).html_urls
        a.save!
        a.should be_just_published
        a = Article.find(a.id)
        a.should_not be_just_published
        # Saving again will not resend the pings
        a.save
      end

    end

    def make_and_send_ping
      Net::HTTP.should_receive(:get_response).and_return(mock_response)
      XMLRPC::Client.should_receive(:new2).with(pingback_target).and_return(mock_xmlrpc_response)

      ping = FactoryGirl.create(:article).pings.build("url" => referenced_url)
      ping.should be_instance_of(Ping)
      ping.url.should == referenced_url
      ping.send_pingback_or_trackback(referrer_url).join
    end
  end

  describe "An article links to another article, which contains a trackback URL" do
    let(:referenced_url) { 'http://anotherblog.org/a-post' }
    let(:trackback_url) { "http://anotherblog.org/a-post/trackback" }
    let!(:blog) { create(:blog) }

    it 'Trackback URL is detected and pinged' do
      referrer_url = 'http://myblog.net/referring-post'
      post = "title=Article+1%21&excerpt=body&url=http://myblog.net/referring-post&blog_name=test+blog"
      article = create(:article, title: 'Article 1!', body: 'body', permalink: 'referring-post')
      make_and_send_ping(post, article, referrer_url)
    end

    it 'sends a trackback without html tag in excerpt' do
      # TODO: Assert the following:
      # contents(:xmltest).body = originally seen on <a href="http://blog.rubyonrails.org/">blog.rubyonrails.org</a>

      article = create(:article, title: "Associations aren't :dependent => true anymore", excerpt: "A content with several data")
      post = "title=#{CGI.escape(article.title)}"
      post << "&excerpt=#{CGI.escape("A content with several data")}" # not original text see if normal ?
      post << "&url=#{article.permalink_url}"
      post << "&blog_name=#{CGI.escape('test blog')}"

      make_and_send_ping(post, article, article.permalink_url)
    end

    it 'sends a trackback without markdown tag in excerpt' do
      # TODO: Assert the following:
      # contents(:markdown_article) #in markdown format\n * we\n * use\n [ok](http://blog.ok.com) to define a link

      article = create(:article, title: "How made link with markdown", excerpt: "A content with several data" )
      post = "title=#{CGI.escape(article.title)}"
      post << "&excerpt=#{CGI.escape("A content with several data")}" # not original text see if normal ?
      post << "&url=#{article.permalink_url}"
      post << "&blog_name=#{CGI.escape('test blog')}"

      make_and_send_ping(post, article, article.permalink_url)
    end

    def make_and_send_ping(post, article, article_url)
      mock = double('html_response')
      Net::HTTP.should_receive(:get_response).with(URI.parse(referenced_url)).and_return(mock)
      mock.should_receive(:[]).with('X-Pingback').at_least(:once)
      mock.should_receive(:body).twice.and_return(referenced_body)
      Net::HTTP.should_receive(:start).with(URI.parse(trackback_url).host, 80).and_yield(mock)

      mock.should_receive(:post).with('/a-post/trackback', post, 'Content-type' => 'application/x-www-form-urlencoded; charset=utf-8').and_return(mock)

      ping = article.pings.create(url: referenced_url)
      ping.send_pingback_or_trackback(article_url).join
    end

    def referenced_body
      r = <<-eobody
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
      r
    end
  end

  describe 'Given a remote site to notify, eg technorati' do
    it 'we can ping them correctly' do
      create(:blog)
      mock = double('response')
      XMLRPC::Client.should_receive(:new2).with('http://rpc.technorati.com/rpc/ping').and_return(mock)
      mock.should_receive(:call).with('weblogUpdates.ping', 'test blog', 'http://myblog.net', 'http://myblog.net/new-post')

      ping = create(:article).pings.build("url" => "http://rpc.technorati.com/rpc/ping")
      ping.send_weblogupdatesping('http://myblog.net', 'http://myblog.net/new-post').join
    end
  end
end
