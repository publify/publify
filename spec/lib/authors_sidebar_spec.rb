require 'rails_helper'

describe AuthorsSidebar do
  let(:configuration) { AuthorsSidebar.new({}) }

  it 'is included in the list of available sidebars' do
    expect(SidebarRegistry.available_sidebars).to include(AuthorsSidebar)
  end

  describe '#authors' do
    let!(:authors) { create_list :user, 2 }

    it 'returns a list of users' do
      expect(configuration.authors).to match_array authors
    end
  end
end
