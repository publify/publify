require 'spec_helper'

describe "trackbacks/index_rss_feed.rss.builder" do
  before do
    stub_default_blog
  end

  describe "rendering trackbacks" do
    let(:article) { stub_full_article }
    let(:trackback) { Factory.build(:trackback, :article => article) }

    before do
      assign(:trackbacks, [trackback])
      render
    end

    it "should render a valid rss feed" do
      assert_feedvalidator rendered
      assert_rss20 rendered, 1
    end

    describe "the trackback entry" do
      it "should have all the required attributes" do
        xml = Nokogiri::XML.parse(rendered)
        entry_xml = xml.css("item").first

        entry_xml.css("title").first.content.should ==
          "Trackback from #{trackback.blog_name}: #{trackback.title} on #{article.title}"
        entry_xml.css("guid").first.content.should == "urn:uuid:dsafsadffsdsf"
        entry_xml.css("description").first.content.should == "This is an excerpt"
        entry_xml.css("link").first.content.should == trackback.url
      end
    end
  end
end
