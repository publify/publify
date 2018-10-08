# frozen_string_literal: true

require 'rails_helper'

describe PageSidebar do
  it 'is available' do
    expect(SidebarRegistry.available_sidebars).to include(PageSidebar)
  end
end
