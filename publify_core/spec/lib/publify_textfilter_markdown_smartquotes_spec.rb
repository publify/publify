# frozen_string_literal: true

require "rails_helper"

RSpec.describe PublifyTextfilter::MarkdownSmartquotes do
  it "applies markdown processing to the supplied text" do
    aggregate_failures do
      expect(described_class.filtertext("*foo*")).
        to eq "<p><em>foo</em></p>"

      expect(described_class.filtertext("foo\n\nbar")).
        to eq "<p>foo</p>\n<p>bar</p>"
    end
  end

  it "applies smart quoting to the supplied text" do
    expect(described_class.filtertext("'foo'")).to eq "<p>‘foo’</p>"
  end

  it "applies nice dashes to the supplied text" do
    expect(described_class.filtertext("foo -- bar")).to eq "<p>foo – bar</p>"
  end

  it "passes through publify macros" do
    result = described_class.filtertext("foo <publify:foo>Hello!</publify:foo>")

    expect(result).to eq "<p>foo <publify:foo>Hello!</publify:foo></p>"
  end
end
