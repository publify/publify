require 'rails_helper'

describe AuthorsSidebar do
  it 'is available' do
    expect(Sidebar.available_sidebars).to include(AuthorsSidebar)
  end
end
