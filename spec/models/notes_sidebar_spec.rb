require 'rails_helper'

describe NotesSidebar do
  it 'is available' do
    expect(Sidebar.available_sidebars).to include(NotesSidebar)
  end
end
