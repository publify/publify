require 'spec_helper'

describe "articles/feedback_atom_feed.atom.builder" do
  before do
    FactoryGirl.create(:blog)
  end

  describe "with one trackback" do
    let(:article) { stub_full_article }
    let(:trackback) { FactoryGirl.build(:trackback, :article => article) }

    before do
      assign(:feedback, [trackback])
      render
    end

    it "should render a valid feed" do
      assert_feedvalidator rendered
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
      end
    end
  end

  describe 'with a comment with problematic characters' do
    let(:article) { stub_full_article }
    let(:comment) { FactoryGirl.build(:comment, :article => article, :body => "&eacute;coute! 4 < 2, non?") }

    before(:each) do
      assign(:feedback, [comment])
      render
    end

    it "should render a valid feed" do
      assert_feedvalidator rendered
    end

    it "should render an Atom feed with one item" do
      assert_atom10 rendered, 1
    end
  end
end

