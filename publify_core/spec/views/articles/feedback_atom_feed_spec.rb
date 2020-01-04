# frozen_string_literal: true

require "rails_helper"

describe "articles/feedback_atom_feed.atom.builder", type: :view do
  let(:article) { create :article }
  let(:parsed_feed) { Feedjira.parse(rendered) }

  describe "with one trackback" do
    let!(:trackback) { create(:trackback, article: article) }

    before do
      assign(:article, article)
      render
    end

    it "renders a valid Atom feed with one item" do
      assert_atom10_feed parsed_feed, 1
    end

    describe "the trackback entry" do
      it "has all the required attributes" do
        entry_xml = parsed_feed.entries.first

        expect(entry_xml.title).to eq(
          "Trackback from #{trackback.blog_name}: #{trackback.title} on #{article.title}")
        expect(entry_xml.entry_id).to eq("urn:uuid:dsafsadffsdsf")
      end
    end

    it "links to the article url" do
      expect(parsed_feed.url).to eq article.permalink_url
    end
  end

  describe "with a comment with problematic characters" do
    let!(:comment) do
      create(:comment, article: article,
                       body: "&eacute;coute! 4 < 2, non?")
    end

    before do
      assign(:article, article)
      render
    end

    it "renders a valid Atom feed with one item" do
      assert_atom10_feed parsed_feed, 1
    end
  end
end
