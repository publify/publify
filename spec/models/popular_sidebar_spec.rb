require 'rails_helper'

describe PopularSidebar do
  it 'is available' do
    expect(Sidebar.available_sidebars).to include(PopularSidebar)
  end
end
