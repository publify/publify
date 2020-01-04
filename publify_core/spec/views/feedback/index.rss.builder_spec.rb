# frozen_string_literal: true

require "rails_helper"

RSpec.describe "feedback/index.rss.builder", type: :view do
  describe "rendering feedback" do
    let(:article) { build_stubbed :article }
    let(:comment) do
      build_stubbed(:comment,
                    article: article,
                    body: "Comment body",
                    guid: "12313123123123123")
    end
    let(:trackback) { build_stubbed(:trackback, article: article) }

    before do
      assign(:feedback, [comment, trackback])
      render
    end

    it "renders a valid rss feed with two entries" do
      assert_rss20 rendered, 2
    end

    describe "the comment entry" do
      let(:rendered_entry) { Feedjira.parse(rendered).entries.first }
      let(:xml_entry) { Nokogiri::XML.parse(rendered).css("item").first }

      it "has all the required attributes" do
        expect(rendered_entry.title).
          to eq "Comment on #{article.title} by #{comment.author}"
        expect(rendered_entry.entry_id).to eq("urn:uuid:12313123123123123")
        expect(rendered_entry.summary).to eq("<p>Comment body</p>")
        expect(xml_entry.css("link").first.content).
          to eq("#{article.permalink_url}#comment-#{comment.id}")
      end
    end

    describe "the trackback entry" do
      let(:rendered_entry) { Feedjira.parse(rendered).entries.last }
      let(:xml_entry) { Nokogiri::XML.parse(rendered).css("item").last }

      it "has all the required attributes" do
        expect(rendered_entry.title).
          to eq "Trackback from #{trackback.blog_name}:" \
          " #{trackback.title} on #{article.title}"
        expect(rendered_entry.entry_id).to eq("urn:uuid:dsafsadffsdsf")
        expect(rendered_entry.summary).to eq("This is an excerpt")
        expect(xml_entry.css("link").first.content).to eq(trackback.url)
      end
    end
  end
end
