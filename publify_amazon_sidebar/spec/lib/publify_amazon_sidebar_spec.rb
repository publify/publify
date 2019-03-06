# frozen_string_literal: true

require "rails_helper"

RSpec.describe PublifyAmazonSidebar do
  it "registers the amazon sidebar" do
    expect(SidebarRegistry.available_sidebars).to include AmazonSidebar
  end
end
