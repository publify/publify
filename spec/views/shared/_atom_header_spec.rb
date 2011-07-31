require 'spec_helper'

describe "shared/_atom_header.atom.builder" do
  before do
    stub_default_blog
  end

  describe "with no items" do
    before do
      @xml = ::Builder::XmlMarkup.new
      @xml.foo do
        render :partial => "shared/atom_header.atom.builder",
          :locals => { :feed => @xml, :items => [] }
      end
    end

    it "shows typo with the current version as the generator" do
      xml = Nokogiri::XML.parse(@xml.target!)
      generator = xml.css("generator").first
      generator.should_not be_nil
      generator.content.should == "Typo"
      generator["version"].should == TYPO_VERSION
    end
  end
end


