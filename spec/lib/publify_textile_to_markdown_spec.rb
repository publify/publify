# frozen_string_literal: true

require "rails_helper"
require "publify_textile_to_markdown"

describe PublifyTextileToMarkdown do
  describe ".convert" do
    it "converts articles" do
      article = create(:article, text_filter_name: "textile", body: "Be *bold*",
                                 extended: "Be __italic__")
      described_class.convert
      article.reload

      aggregate_failures do
        expect(article.body).to eq "Be **bold**\n\n"
        expect(article.extended).to eq "Be _italic_\n\n"
        expect(article.text_filter_name).to eq "markdown"
      end
    end

    it "converts pages" do
      page = create :page, text_filter_name: "textile", body: "Be *bold*"
      described_class.convert
      page.reload

      aggregate_failures do
        expect(page.body).to eq "Be **bold**\n\n"
        expect(page.text_filter_name).to eq "markdown"
      end
    end

    it "converts notes" do
      note = create :note, text_filter_name: "textile", body: "Be *bold*"
      described_class.convert
      note.reload

      aggregate_failures do
        expect(note.body).to eq "Be **bold**\n\n"
        expect(note.text_filter_name).to eq "markdown"
      end
    end

    it "converts comments" do
      comment = create :comment, text_filter_name: "textile", body: "Be *bold*"
      described_class.convert
      comment.reload

      aggregate_failures do
        expect(comment.body).to eq "Be **bold**\n\n"
        expect(comment.text_filter_name).to eq "markdown"
      end
    end

    it "converts trackbacks in the unlikely case that they use textile" do
      trackback = create :trackback, text_filter_name: "textile", excerpt: "Be *bold*"
      described_class.convert
      trackback.reload

      aggregate_failures do
        expect(trackback.excerpt).to eq "Be **bold**\n\n"
        expect(trackback.text_filter_name).to eq "markdown"
      end
    end

    it "does not convert content with a different text filter" do
      page = create :page, text_filter_name: "none", body: "Be *bold*"
      described_class.convert
      page.reload

      aggregate_failures do
        expect(page.body).to eq "Be *bold*"
        expect(page.text_filter_name).to eq "none"
      end
    end

    it "does not convert feedback with a different text filter" do
      comment = create :comment, text_filter_name: "none", body: "Be *bold*"
      described_class.convert
      comment.reload

      aggregate_failures do
        expect(comment.body).to eq "Be *bold*"
        expect(comment.text_filter_name).to eq "none"
      end
    end
  end
end
