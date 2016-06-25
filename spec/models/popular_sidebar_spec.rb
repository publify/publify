require 'rails_helper'

describe PopularSidebar do
  it 'is available' do
    expect(SidebarRegistry.available_sidebars).to include(PopularSidebar)
  end
end
