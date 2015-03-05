require 'rails_helper'

describe ArchivesSidebar do
  let(:sidebar) { ArchivesSidebar.new }

  it 'is included in the list of available sidebars' do
    expect(Sidebar.available_sidebars).to include(ArchivesSidebar)
  end

  describe '#parse_request' do
    before { build_stubbed :blog }

    it 'creates correct month + year labels' do
      create :article, published_at: DateTime.new(2014, 3, 2)
      sidebar.parse_request nil, nil

      expect(sidebar.archives.first[:name]).to eq 'March 2014'
    end
  end
end
