require 'rails_helper'

describe XmlSidebar do
  it 'is available' do
    expect(Sidebar.available_sidebars).to include(XmlSidebar)
  end
end
