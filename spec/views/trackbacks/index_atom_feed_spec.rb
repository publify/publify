require 'spec_helper'

describe "trackbacks/index_atom_feed.atom.builder" do
  let!(:blog) { build_stubbed :blog }

  describe "rendering trackbacks with one trackback" do
    let(:article) { create(:article) }
    let(:trackback) { create(:trackback, :article => article) }

    before(:each) do
      assign(:items, [trackback])
      render
    end

    it "should render a valid feed" do
      assert_feedvalidator rendered
    end

    it "shows publify with the current version as the generator" do
      xml = Nokogiri::XML.parse(rendered)
      generator = xml.css("generator").first
      generator.content.should == "Publify"
      generator["version"].should == PUBLIFY_VERSION
    end

    it "should render an Atom feed with one item" do
      assert_atom10 rendered, 1
    end

    describe "the trackback entry" do
      it "should have all the required attributes" do
        xml = Nokogiri::XML.parse(rendered)
        entry_xml = xml.css("entry").first

        entry_xml.css("title").first.content.should ==
          "Trackback from #{trackback.blog_name}: #{trackback.title} on #{article.title}"
        entry_xml.css("id").first.content.should == "urn:uuid:dsafsadffsdsf"
        entry_xml.css("summary").first.content.should == "This is an excerpt"
        link_xml = entry_xml.css("link").first
        link_xml["href"].should == "#{article.permalink_url}#trackback-#{trackback.id}"
      end
    end
  end
end
