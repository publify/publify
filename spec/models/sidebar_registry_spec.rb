# frozen_string_literal: true

require "rails_helper"

RSpec.describe SidebarRegistry do
  describe "#available_sidebars" do
    it "finds at least the standard sidebars" do
      expect(described_class.available_sidebars).
        to include(AmazonSidebar,
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
                   XmlSidebar)
    end
  end
end
