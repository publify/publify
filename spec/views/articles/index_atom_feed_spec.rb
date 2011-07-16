require 'spec_helper'

describe "articles/index_atom_feed.atom.builder" do
  before do
    stub_default_blog
  end

  describe "with no items" do
    before do
      assign(:articles, [])
      render
    end

    it "shows typo with the current version as the generator" do
      xml = Nokogiri::XML.parse(rendered)
      generator = xml.css("generator").first
      generator.content.should == "Typo"
      generator["version"].should == TYPO_VERSION
    end
  end

  describe "rendering articles" do
    it 'should create valid atom feed when articles contains funny bits' do
      article1 = stub_full_article(1.minute.ago)
      article1.body = '&eacute;coute!'
      article2 = stub_full_article(2.minutes.ago)
      article2.body = 'is 4 < 2? no!'
      assign(:articles, [article1, article2])

      render

      assert_feedvalidator rendered
      assert_atom10 rendered, 2
    end
  end
end

