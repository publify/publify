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
      render
      rendered_entry.css("id").first.content.should == "urn:uuid:#{@article.guid}"
    end

    describe "on a blog that shows extended content in feeds" do
      before do
        Blog.default.hide_extended_on_rss = false
        render
      end

      it "shows the body and extended content in the feed" do
        rendered_entry.css("content").first.content.should =~ /public info.*and more/m
      end

      it "does not have a summary element in addition to the content element" do
        rendered_entry.css("summary").should be_empty
      end
    end

    describe "on a blog that hides extended content in feeds" do
      before do
        Blog.default.hide_extended_on_rss = true
        render
      end

      it "shows only the body content in the feed" do
        entry = rendered_entry
        entry.css("content").first.content.should =~ /public info/
        entry.css("content").first.content.should_not =~ /public info.*and more/m
      end

      it "does not have a summary element in addition to the content element" do
        rendered_entry.css("summary").should be_empty
      end
    end

    describe "on a blog that has an RSS description set" do
      before do
        Blog.default.rss_description = true
        Blog.default.rss_description_text = "rss description"
        render
      end

      it "shows the body content in the feed" do
        rendered_entry.css("content").first.content.should =~ /public info/
      end

      it "shows the RSS description in the feed" do
        rendered_entry.css("content").first.content.should =~ /rss description/
      end
    end

  end

  describe "rendering a password protected article" do
    before do
      @article = stub_full_article
      @article.body = "shh .. it's a secret!"
      @article.extended = "even more secret!"
      @article.stub(:password) { "password" }
      assign(:articles, [@article])
    end

    describe "on a blog that shows extended content in feeds" do
      before do
        Blog.default.hide_extended_on_rss = false
        render
      end

      it "shows only a link to the article" do
        rendered_entry.css("content").first.content.should ==
          "<p>This article is password protected. Please <a href='#{@article.permalink_url}'>fill in your password</a> to read it</p>"
      end

      it "does not have a summary element in addition to the content element" do
        rendered_entry.css("summary").should be_empty
      end

      it "does not show any secret bits anywhere" do
        rendered.should_not =~ /secret/
      end
    end

    describe "on a blog that hides extended content in feeds" do
      before do
        Blog.default.hide_extended_on_rss = true
        render
      end

      it "shows only a link to the article" do
        rendered_entry.css("content").first.content.should ==
          "<p>This article is password protected. Please <a href='#{@article.permalink_url}'>fill in your password</a> to read it</p>"
      end

      it "does not have a summary element in addition to the content element" do
        rendered_entry.css("summary").should be_empty
      end

      it "does not show any secret bits anywhere" do
        rendered.should_not =~ /secret/
      end
    end
  end

  def rendered_entry
    parsed = Nokogiri::XML.parse(rendered)
    parsed.css("entry").first
  end
end

