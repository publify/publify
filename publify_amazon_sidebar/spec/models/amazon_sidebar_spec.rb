# frozen_string_literal: true

require "rails_helper"

RSpec.describe AmazonSidebar do
  describe "when using default values for its properties" do
    let(:sidebar) { Sidebar.new(type: "AmazonSidebar", blog: Blog.new) }
    let(:config) { sidebar.configuration }

    it "title should be 'Cited books'" do
      expect(config.title).to eq("Cited books")
    end

    it "associate_id should be 'justasummary-20'" do
      expect(config.associate_id).to eq("justasummary-20")
    end

    it "maxlinks should be 4" do
      expect(config.maxlinks).to eq(4)
    end

    it "description should be 'Adds sidebar links...'" do
      expect(config.description).to eq(
        "Adds sidebar links to any Amazon.com books linked in the body of the page")
    end

    it "sidebar should be valid" do
      expect(sidebar).to be_valid
    end
  end

  describe "when overriding the defaults" do
    it "gets attributes set correctly" do
      sb = Sidebar.new(blog: Blog.new,
                       type: "AmazonSidebar",
                       config: { "title" => "Books",
                                 "associate_id" => "justasummary-21",
                                 "maxlinks" => 3 })
      conf = sb.configuration
      expect(sb).to be_valid
      expect(conf.title).to eq("Books")
      expect(conf.associate_id).to eq("justasummary-21")
      expect(conf.maxlinks).to eq(3)
    end
  end
end
