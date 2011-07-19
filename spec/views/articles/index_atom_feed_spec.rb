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

    it "renders the atom header partial" do
      view.should render_template(:partial => "shared/_atom_header")
    end
  end

  describe "rendering articles (with some funny characters)" do
    before do
      article1 = stub_full_article(1.minute.ago)
      article1.body = '&eacute;coute!'
      article2 = stub_full_article(2.minutes.ago)
      article2.body = 'is 4 < 2? no!'
      assign(:articles, [article1, article2])

      render
    end

    it "creates a valid feed" do
      assert_feedvalidator rendered
    end

    it "creates an atom feed with two items" do
      assert_atom10 rendered, 2
    end

    it "renders the article atom partial twice" do
      view.should render_template(:partial => "shared/_atom_item_article",
                                  :count => 2)
    end
  end

  describe "rendering a single article" do
    before do
      @article = stub_full_article
      @article.body = "public info"
      @article.extended = "and more"
      assign(:articles, [@article])
    end

    it "has the correct id" do
      entry = render_and_parse_entry
      entry.css("id").first.content.should == "urn:uuid:#{@article.guid}"
    end

    describe "on a blog that shows extended content in feeds" do
      before do
        Blog.default.hide_extended_on_rss = false
      end

      it "shows the body and extended content in the feed" do
        entry = render_and_parse_entry
        entry.css("content").first.content.should =~ /^\s*public info\s*and more\s*$/
      end
    end

    describe "on a blog that hides extended content in feeds" do
      before do
        Blog.default.hide_extended_on_rss = true
      end

      it "shows only the body content in the feed" do
        entry = render_and_parse_entry
        entry.css("content").first.content.should =~ /^\s*public info\s*$/
        entry.css("content").first.content.should_not =~ /^\s*public info\s*and more\s*$/
      end
    end
  end

  describe "rendering a password protected article" do
    before do
      @article = stub_full_article
      @article.body = "shh .. it's a secret!"
      @article.stub(:password) { "password" }
      assign(:articles, [@article])
    end

    it "shows only a link to the article" do
      entry = render_and_parse_entry
      entry.css("content").first.content.should ==
        "<p>This article is password protected. Please <a href='#{@article.permalink_url}'>fill in your password</a> to read it</p>"
    end
  end

  def render_and_parse_entry
    render
    parsed = Nokogiri::XML.parse(rendered)
    parsed.css("entry").first
  end
end

