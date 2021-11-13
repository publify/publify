# frozen_string_literal: true

require "rails_helper"

RSpec.describe "articles/index_atom_feed.atom.builder", type: :view do
  let(:parsed_feed) { Feedjira.parse(rendered) }
  let(:rendered_entry) { parsed_feed.entries.first }

  describe "with no items" do
    before do
      assign(:articles, [])
      render
    end

    it "renders the atom header partial" do
      expect(view).to render_template(partial: "shared/_atom_header")
    end
  end

  describe "rendering articles (with some funny characters)" do
    let!(:blog) { create :blog }

    before do
      article1 = create :full_article, published_at: 1.minute.ago
      article1.body = "&eacute;coute!"
      article2 = create :full_article, published_at: 2.minutes.ago
      article2.body = "is 4 < 2? no!"
      assign(:articles, [article1, article2])
      render
    end

    it "creates a valid atom feed with two items" do
      assert_atom10_feed parsed_feed, 2
    end

    it "renders the article atom partial twice" do
      expect(view).to render_template(partial: "shared/_atom_item_article", count: 2)
    end

    it "links to the main blog url" do
      expect(parsed_feed.url).to eq blog.base_url
    end
  end

  describe "rendering a single article" do
    let(:blog) { create :blog }

    before do
      @article = create :full_article, blog: blog
      @article.body = "public info"
      @article.extended = "and more"
      @article.published_at = 2.weeks.ago
      assign(:articles, [@article])
    end

    it "has the correct guid" do
      render
      expect(rendered_entry.entry_id).to eq "urn:uuid:#{@article.guid}"
    end

    it "has the correct publication date" do
      render
      expect(rendered_entry.published.to_s).to eq @article.published_at.to_s
    end

    describe "on a blog that shows extended content in feeds" do
      let(:blog) { create :blog, hide_extended_on_rss: false }

      before do
        render
      end

      it "shows the body and extended content in the feed" do
        expect(rendered_entry.content).to match(/public info.*and more/m)
      end

      it "does not have a summary element in addition to the content element" do
        expect(rendered_entry.summary).to be_nil
      end
    end

    describe "on a blog that hides extended content in feeds" do
      let(:blog) { create :blog, hide_extended_on_rss: true }

      it "shows the body content if there is no excerpt" do
        render
        expect(rendered_entry.content).to match(/public info/)
        expect(rendered_entry.content).not_to match(/public info.*and more/m)
      end

      it "shows the excerpt but no body content, if there is an excerpt" do
        @article.excerpt = "excerpt"
        render
        expect(rendered_entry.content).to match(/excerpt/)
        expect(rendered_entry.content).not_to match(/public info/)
      end

      it "does not have a summary element in addition to the content element" do
        render
        expect(rendered_entry.summary).to be_nil
      end
    end

    describe "on a blog that has an RSS description set" do
      let(:blog) do
        create :blog, rss_description: true,
                      rss_description_text: "rss description"
      end

      before do
        render
      end

      it "shows the body content in the feed" do
        expect(rendered_entry.content).to match(/public info/)
      end

      it "shows the RSS description in the feed" do
        expect(rendered_entry.content).to match(/rss description/)
      end
    end
  end

  describe "rendering a password protected article" do
    before do
      @article = create :full_article, blog: blog
      @article.body = "shh .. it's a secret!"
      @article.extended = "even more secret!"
      allow(@article).to receive(:password).and_return("password")
      assign(:articles, [@article])
      render
    end

    describe "on a blog that shows extended content in feeds" do
      let(:blog) { create :blog, hide_extended_on_rss: false }

      it "shows only a link to the article" do
        expect(rendered_entry.content).
          to eq "<p>This article is password protected. Please" \
                " <a href='#{@article.permalink_url}'>fill in your password</a>" \
                " to read it</p>"
      end

      it "does not have a summary element in addition to the content element" do
        expect(rendered_entry.summary).to be_nil
      end

      it "does not show any secret bits anywhere" do
        expect(rendered).not_to match(/secret/)
      end
    end

    describe "on a blog that hides extended content in feeds" do
      let(:blog) { create :blog, hide_extended_on_rss: true }

      it "shows only a link to the article" do
        expect(rendered_entry.content).
          to eq "<p>This article is password protected. Please" \
                " <a href='#{@article.permalink_url}'>fill in your password</a>" \
                " to read it</p>"
      end

      it "does not have a summary element in addition to the content element" do
        expect(rendered_entry.summary).to be_nil
      end

      it "does not show any secret bits anywhere" do
        expect(rendered).not_to match(/secret/)
      end
    end
  end

  describe "#title" do
    before do
      assign(:articles, [article])
      render
    end

    context "with a note" do
      let(:article) { create(:note) }

      it "is equal to the note body" do
        expect(rendered_entry.title).to eq(article.body)
      end
    end

    context "with an article" do
      let(:article) { create(:article) }

      it "is equal to the article title" do
        expect(rendered_entry.title).to eq(article.title)
      end
    end
  end
end
