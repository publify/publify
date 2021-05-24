# frozen_string_literal: true

require "rails_helper"

RSpec.describe TextFilter do
  describe "#filter_text" do
    it "works for markdown" do
      filter = described_class.markdown
      expect(filter.filter_text('*"foo"*')).to eq "<p><em>&quot;foo&quot;</em></p>"
    end

    xit "works for markdown with smart quotes" do
      filter = described_class.markdown_smartypants
      expect(filter.filter_text('*"foo"*')).to eq "<p><em>&#8220;foo&#8221;</em></p>"
    end

    it "works for smart quotes" do
      filter = described_class.smartypants
      expect(filter.filter_text('I am "smart"')).to eq "I am &#8220;smart&#8221;"
    end
  end

  describe "#help" do
    it "works for the 'none' filter" do
      expect(described_class.none.help).to start_with "\n"
    end

    it "works for the 'markdown' filter" do
      expect(described_class.markdown.help).to start_with "<h3>Markdown</h3>\n"
    end
  end

  describe "#commenthelp" do
    it "works for the 'none' filter" do
      expect(described_class.none.commenthelp).to eq ""
    end

    it "works for the 'markdown' filter" do
      expect(described_class.markdown.commenthelp).
        to start_with(
          "<p><a href=\"http://daringfireball.net/projects/markdown/\">Markdown</a>" \
          " is a simple")
    end
  end
end
