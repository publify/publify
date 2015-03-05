require 'rails_helper'

describe SearchSidebar do
  it 'is available' do
    expect(Sidebar.available_sidebars).to include(SearchSidebar)
  end
end
