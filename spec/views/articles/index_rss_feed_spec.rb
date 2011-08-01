# coding: utf-8
require 'spec_helper'

describe "articles/index_rss_feed.rss.builder" do
  before do
    stub_default_blog
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

    it "creates an RSS feed with two items" do
      assert_rss20 rendered, 2
    end

    it "renders the article RSS partial twice" do
      view.should render_template(:partial => "shared/_rss_item_article",
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

    it "has the correct guid" do
      render
      rendered_entry.css("guid").first.content.should == "urn:uuid:#{@article.guid}"
    end

    it "has a link to the article's comment section" do
      render
      rendered_entry.css("comments").first.content.should == @article.permalink_url + "#comments"
    end

    describe "with an author without email set" do
      before do
        @article.user.email = nil
        render
      end

      it "does not have an author entry" do
        rendered_entry.css("author").should be_empty
      end
    end

    describe "with an author with email set" do
      before do
        @article.user.email = 'foo@bar.com'
      end

      describe "on a blog that links to the author" do
        before do
          Blog.default.link_to_author = true
          render
        end

        it "has an author entry" do
          rendered_entry.css("author").should_not be_empty
        end

        it "has the author's email in the author entry" do
          rendered_entry.css("author").first.content.should =~ /foo@bar.com/
        end
      end

      describe "on a blog that does not link" do
        before do
          Blog.default.link_to_author = false
          render
        end

        it "does not have an author entry" do
          rendered_entry.css("author").should be_empty
        end
      end
    end

    describe "on a blog that shows extended content in feeds" do
      before do
        Blog.default.hide_extended_on_rss = false
        render
      end

      it "shows the body and extended content in the feed" do
        rendered_entry.css("description").first.content.should =~ /public info.*and more/m
      end
    end

    describe "on a blog that hides extended content in feeds" do
      before do
        Blog.default.hide_extended_on_rss = true
        render
      end

      it "shows only the body content in the feed" do
        entry = rendered_entry
        entry.css("description").first.content.should =~ /public info/
        entry.css("description").first.content.should_not =~ /public info.*and more/m
      end
    end

    describe "on a blog that has an RSS description set" do
      before do
        Blog.default.rss_description = true
        Blog.default.rss_description_text = "rss description"
        render
      end

      it "shows the body and extended content in the feed" do
        rendered_entry.css("description").first.content.should =~ /public info.*and more/m
      end

      it "shows the RSS description in the feed" do
        rendered_entry.css("description").first.content.should =~ /rss description/
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
        rendered_entry.css("description").first.content.should ==
          "<p>This article is password protected. Please <a href='#{@article.permalink_url}'>fill in your password</a> to read it</p>"
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
        rendered_entry.css("description").first.content.should ==
          "<p>This article is password protected. Please <a href='#{@article.permalink_url}'>fill in your password</a> to read it</p>"
      end

      it "does not show any secret bits anywhere" do
        rendered.should_not =~ /secret/
      end
    end
  end

  describe "rendering an article with a UTF-8 permalink" do
    before do
      @article = stub_full_article
      @article.permalink = 'ルビー'
      assign(:articles, [@article])

      render
    end

    it "creates a valid feed" do
      assert_feedvalidator rendered
    end
  end

  def rendered_entry
    parsed = Nokogiri::XML.parse(rendered)
    parsed.css("item").first
  end
end

