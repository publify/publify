require 'spec_helper'

describe "shared/rss20_feed.rss.builder" do
  before do
    blog = stub_model(Blog, :base_url => "http://myblog.net")
    view.stub(:this_blog) { blog }
    Blog.stub(:default) { blog }
  end

  let(:author) { stub_model(User, :name => "not empty") }

  let(:text_filter) { stub_model(TextFilter) }

  def base_article(time=Time.now)
    a = stub_model(Article, :published_at => time, :user => author,
                   :created_at => time, :updated_at => time,
                   :title => "not empty either", :permalink => 'foo-bar',
                   :guid => time.hash)
    a.stub(:tags) { [] }
    a.stub(:categories) { [] }
    a.stub(:resources) { [] }
    a.stub(:text_filter) { text_filter }
    a
  end

  describe "rendering articles" do
    it 'should create valid rss feed when articles contains funny bits' do
      article1 = base_article(1.minute.ago)
      article1.body = '&eacute;coute!'
      article2 = base_article(2.minutes.ago)
      article2.body = 'is 4 < 2? no!'
      render "shared/rss20_feed", :items => [article1, article2],
        :feed_url => "http://full-feedurl.com/feed"
      assert_feedvalidator rendered
      assert_rss20 rendered, 2
    end
  end

  describe "rendering trackbacks" do
    let(:article) { base_article }
    let(:trackback) { Factory.build(:trackback, :article => article) }

    it "should render a valid rss feed" do
      render "shared/rss20_feed", :items => [trackback],
        :feed_url => "http://full-feedurl.com/feed"
      assert_feedvalidator rendered
      assert_rss20 rendered, 1
    end
  end

  def assert_rss20 feed, count
    doc = Nokogiri::XML.parse(feed)
    root = doc.css(':root').first
    root.name.should == "rss"
    root['version'].should == "2.0"
    root.css('channel item').count.should == count
  end
end
