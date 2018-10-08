# frozen_string_literal: true

require 'rails_helper'

describe SearchSidebar do
  it 'is available' do
    expect(SidebarRegistry.available_sidebars).to include(described_class)
  end
end
