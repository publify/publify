require 'rails_helper'

describe XmlSidebar do
  it 'is available' do
    expect(SidebarRegistry.available_sidebars).to include(XmlSidebar)
  end
end
