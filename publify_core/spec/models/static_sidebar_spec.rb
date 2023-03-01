# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Given a new StaticSidebar", type: :model do
  before do
    @sidebar = Sidebar.new(type: "StaticSidebar")
    @config = @sidebar.configuration
  end

  it "title should be Links" do
    expect(@config.title).to eq("Links")
  end

  it "body should be our default" do
    expect(@config.body).to eq(StaticSidebar::DEFAULT_TEXT)
  end

  it "description should be set correctly" do
    expect(@config.description).
      to eq "Static content, like links to other sites, advertisements," \
            " or blog meta-information"
  end
end
