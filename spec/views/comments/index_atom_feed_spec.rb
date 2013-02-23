require 'spec_helper'

describe "comments/index_atom_feed.atom.builder" do
  before do
    stub_default_blog
  end

  describe "rendering comments with one comment" do
    let(:article) { stub_full_article }
    let(:comment) { FactoryGirl.build(:comment,
                                      article: article,
                                      body: "Comment body",
                                      guid: '12313123123123123') }

    before do
      assign(:comments, [comment])
      render
    end

    it "should render a valid feed" do
      assert_feedvalidator rendered
    end

    it "shows typo with the current version as the generator" do
      xml = Nokogiri::XML.parse(rendered)
      generator = xml.css("generator").first
      generator.content.should == "Typo"
      generator["version"].should == TYPO_VERSION
    end

    it "should render an Atom feed with one item" do
      assert_atom10 rendered, 1
    end

    describe "the comment entry" do
      it "should have all the required attributes" do
        xml = Nokogiri::XML.parse(rendered)
        entry_xml = xml.css("entry").first

        entry_xml.css("title").first.content.should ==
          "Comment on #{article.title} by #{comment.author}"
        entry_xml.css("id").first.content.should == "urn:uuid:12313123123123123"
        entry_xml.css("content").first.content.should == "<p>Comment body</p>"
        link_xml = entry_xml.css("link").first
        link_xml["href"].should == "#{article.permalink_url}#comment-#{comment.id}"
      end
    end
  end
end
