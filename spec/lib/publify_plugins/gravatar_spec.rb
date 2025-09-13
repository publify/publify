# frozen_string_literal: true

require "rails_helper"

RSpec.describe PublifyPlugins::Gravatar do
  describe ".get_avatar" do
    let(:email) { "foo@bar.baz" }
    let(:digest) { Digest::MD5.hexdigest(email) }
    let(:gravatar_tag) { described_class.get_avatar(email: email) }

    it "returns an html safe string" do
      expect(gravatar_tag).to be_html_safe
    end

    it "returns image tag with the correct URL" do
      doc = Nokogiri.parse gravatar_tag
      element = doc.root
      aggregate_failures do
        expect(element.name).to eq "img"
        expect(element.attr("src"))
          .to eq "https://www.gravatar.com/avatar.php?gravatar_id=#{digest}&size=48"
      end
    end
  end
end
