# frozen_string_literal: true

require "rails_helper"

RSpec.describe TagSidebar do
  it "is available" do
    expect(SidebarRegistry.available_sidebars).to include(described_class)
  end

  describe "#tags" do
    let(:sidebar) { described_class.new }

    it "returns tags with counters" do
      create :article, keywords: "foo, bar"
      create :article, keywords: "foo, baz"

      result = sidebar.tags
      aggregate_failures do
        expect(result.map(&:name)).to eq ["bar", "baz", "foo"]
        expect(result.map(&:content_counter)).to eq [1, 1, 2]
      end
    end
  end

  describe "#sizes" do
    let(:sidebar) { described_class.new }

    it "returns tags with sizes" do
      create :article, keywords: "foo, bar"
      create :article, keywords: "foo, baz"

      result = sidebar.sizes
      aggregate_failures do
        expect(result.keys.map(&:name)).to eq ["bar", "baz", "foo"]
        expect(result.values).to eq [75, 75, 150]
      end
    end
  end
end
