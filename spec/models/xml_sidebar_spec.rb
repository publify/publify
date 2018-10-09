# frozen_string_literal: true

require 'rails_helper'

describe XmlSidebar do
  it 'is available' do
    expect(SidebarRegistry.available_sidebars).to include(described_class)
  end
end
