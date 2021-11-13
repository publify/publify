# frozen_string_literal: true

require "rails_helper"

RSpec.describe PublifyApp::Textfilter::Twitterfilter do
  describe ".filtertext" do
    it "replaces a hashtag with a proper URL to Twitter search" do
      text = described_class.filtertext("A test tweet with a #hashtag")
      expect(text).
        to eq "A test tweet with a <a href=\"https://twitter.com/search?q=%23hashtag" \
              "&amp;src=tren&amp;mode=realtime\">#hashtag</a>"
    end

    it "replaces a @mention by a proper URL to the twitter account" do
      text = described_class.filtertext("A test tweet with a @mention")
      expect(text).
        to eq("A test tweet with a <a href=\"https://twitter.com/mention\">@mention</a>")
    end

    it "replaces a http URL by a proper link" do
      text = described_class.filtertext("A test tweet with a http://link.com")
      expect(text).to eq("A test tweet with a <a href=\"http://link.com\">http://link.com</a>")
    end

    it "replaces a https URL with a proper link" do
      text = described_class.filtertext("A test tweet with a https://link.com")
      expect(text).
        to eq("A test tweet with a <a href=\"https://link.com\">https://link.com</a>")
    end

    it "works with a hashtag and a mention" do
      text = described_class.filtertext("A test tweet with a #hashtag and a @mention")
      expect(text).
        to eq("A test tweet with a <a href=\"https://twitter.com/search?q=%23hashtag" \
              "&amp;src=tren&amp;mode=realtime\">#hashtag</a> and a" \
              " <a href=\"https://twitter.com/mention\">@mention</a>")
    end
  end
end
