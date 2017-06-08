require 'rails_helper'

describe ArchivesSidebar do
  let(:sidebar) { ArchivesSidebar.new }

  it 'is included in the list of available sidebars' do
    expect(SidebarRegistry.available_sidebars).to include(ArchivesSidebar)
  end

  describe '#parse_request' do
    before { build_stubbed :blog }

    it 'creates the correct data structure for each month' do
      create :article, published_at: DateTime.new(2014, 3, 2).in_time_zone
      create :article, published_at: DateTime.new(2015, 2, 2).in_time_zone
      create :article, published_at: DateTime.new(2015, 2, 5).in_time_zone

      sidebar.parse_request nil, nil

      expected_structure = [
        { name: 'February 2015', month: 2, year: 2015, article_count: 2 },
        { name: 'March 2014', month: 3, year: 2014, article_count: 1 }
      ]

      expect(sidebar.archives).to eq expected_structure
    end
  end
end
