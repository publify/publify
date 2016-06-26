require 'rails_helper'

describe NotesSidebar do
  it 'is available' do
    expect(SidebarRegistry.available_sidebars).to include(NotesSidebar)
  end
end
