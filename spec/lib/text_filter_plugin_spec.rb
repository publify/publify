# frozen_string_literal: true

require "rails_helper"

RSpec.describe TextFilterPlugin do
  describe ".available_filters" do
    subject { described_class.available_filters }

    it "lists usable filters" do
      expect(described_class.available_filters).to contain_exactly(
        PublifyCore::TextFilter::None,
        PublifyCore::TextFilter::Markdown,
        PublifyCore::TextFilter::Smartypants,
        PublifyCore::TextFilter::MarkdownSmartquotes,
        PublifyCore::TextFilter::Twitterfilter,
        PublifyApp::Textfilter::Htmlfilter,
        PublifyApp::Textfilter::Flickr,
        PublifyApp::Textfilter::Code,
        PublifyApp::Textfilter::Lightbox)
    end
  end

  describe ".macro_filters" do
    subject { described_class.macro_filters }

    it "lists the macro filters" do
      expect(described_class.macro_filters).to contain_exactly(
        PublifyApp::Textfilter::Flickr,
        PublifyApp::Textfilter::Code,
        PublifyApp::Textfilter::Lightbox)
    end
  end
end
