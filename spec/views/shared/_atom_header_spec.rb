require 'spec_helper'

describe "shared/_atom_header.atom.builder" do
  let!(:blog) { create :blog }

  describe "with no items" do
    it "shows publify with the current version as the generator" do
      xml = ::Builder::XmlMarkup.new
      xml.foo do
        render partial: "shared/atom_header",
          formats: [:atom], handlers: [:builder],
          locals: { feed: xml, items: [] }
      end

      xml = Nokogiri::XML.parse(xml.target!)
      generator = xml.css("generator").first

      expect(generator).to_not be_nil
      expect(generator.content).to eq("Publify")
      expect(generator["version"]).to eq(PUBLIFY_VERSION)
    end
  end
end
