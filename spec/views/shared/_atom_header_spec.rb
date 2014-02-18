require 'spec_helper'

describe "shared/_atom_header.atom.builder" do
  let!(:blog) { build_stubbed :blog }

  describe "with no items" do
    before(:each) do
      @xml = ::Builder::XmlMarkup.new
      @xml.foo do
        render partial: "shared/atom_header",
          formats: [:atom], handlers: [:builder],
          locals: { feed: @xml, items: [] }
      end
    end

    it "shows publify with the current version as the generator" do
      xml = Nokogiri::XML.parse(@xml.target!)
      generator = xml.css("generator").first
      generator.should_not be_nil
      generator.content.should == "Publify"
      generator["version"].should == PUBLIFY_VERSION
    end
  end
end
