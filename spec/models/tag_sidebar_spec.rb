require 'rails_helper'

describe TagSidebar do
  it 'is available' do
    expect(Sidebar.available_sidebars).to include(TagSidebar)
  end
end
