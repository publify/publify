# frozen_string_literal: true

require "rails_helper"

describe "authors/show_atom_feed.atom.builder", type: :view do
  let!(:blog) { create(:blog) }
  let(:author) { create :user }
  let(:parsed_feed) { Feedjira.parse(rendered) }

  describe "with no items" do
    before do
      assign(:author, author)
      assign(:articles, [])
      render
    end

    it "renders the atom header partial" do
      expect(view).to render_template(partial: "shared/_atom_header")
    end

    it "links to the author url" do
      expect(parsed_feed.url).to eq author_url(author)
    end
  end

  describe "rendering articles (with some funny characters)" do
    before do
      article1 = create :full_article, published_at: 1.minute.ago
      article1.body = "&eacute;coute!"
      article2 = create :full_article, published_at: 2.minutes.ago
      article2.body = "is 4 < 2? no!"
      assign(:author, author)
      assign(:articles, [article1, article2])
      render
    end

    it "creates a valid atom feed with two items" do
      assert_atom10_feed parsed_feed, 2
    end

    it "renders the article atom partial twice" do
      expect(view).to render_template(partial: "shared/_atom_item_article", count: 2)
    end
  end
end
