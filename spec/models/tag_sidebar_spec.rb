require 'rails_helper'

describe TagSidebar do
  it 'is available' do
    expect(SidebarRegistry.available_sidebars).to include(TagSidebar)
  end
end
