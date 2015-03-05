require 'rails_helper'

describe PageSidebar do
  it 'is available' do
    expect(Sidebar.available_sidebars).to include(PageSidebar)
  end
end
