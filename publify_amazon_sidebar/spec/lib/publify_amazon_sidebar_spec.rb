require 'rails_helper'

describe PublifyAmazonSidebar do
  it 'registers the amazon sidebar' do
    expect(SidebarRegistry.available_sidebars).to include AmazonSidebar
  end
end
