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
end
