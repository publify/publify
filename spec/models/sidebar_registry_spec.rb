require 'rails_helper'

describe SidebarRegistry do
  describe '#available_sidebars' do
    it 'finds at least the standard sidebars' do
      expect(SidebarRegistry.available_sidebars).to include(
        AmazonSidebar,
        ArchivesSidebar,
        AuthorsSidebar,
        LivesearchSidebar,
        MetaSidebar,
        NotesSidebar,
        PageSidebar,
        PopularSidebar,
        SearchSidebar,
        StaticSidebar,
        TagSidebar,
        XmlSidebar
      )
    end
  end
end
