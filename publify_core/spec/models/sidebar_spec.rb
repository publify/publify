# frozen_string_literal: true

require "rails_helper"

RSpec.describe Sidebar, type: :model do
  describe "#ordered_sidebars" do
    let(:blog) { create :blog }

    context "with several sidebars with different positions" do
      let(:search_sidebar) { SearchSidebar.new(staged_position: 2, blog: blog) }
      let(:static_sidebar) { StaticSidebar.new(active_position: 1, blog: blog) }

      before do
        search_sidebar.save
        static_sidebar.save
      end

      it "resturns the sidebars ordered by position" do
        sidebars = described_class.ordered_sidebars
        expect(sidebars).to eq([static_sidebar, search_sidebar])
      end
    end

    context "with an invalid sidebar in the database" do
      before do
        described_class.class_eval { self.inheritance_column = :bogus }
        described_class.new(type: "SearchSidebar", staged_position: 1, blog: blog).save
        described_class.new(type: "FooBarSidebar", staged_position: 2, blog: blog).save
        described_class.class_eval { self.inheritance_column = :type }
      end

      it "skips the invalid active sidebar" do
        sidebars = described_class.ordered_sidebars
        expect(sidebars.size).to eq(1)
        expect(sidebars.first.class).to eq(SearchSidebar)
      end
    end
  end

  describe "#content_partial" do
    it "bases the partial name on the class name" do
      expect(SearchSidebar.new.content_partial).to eq("/search_sidebar/content")
    end
  end

  describe "#configuration_class" do
    let(:sidebar) { Sidebar.new(type: "ArchivesSidebar") }

    it "returns the type, classified" do
      expect(sidebar.configuration_class).to eq ArchivesSidebar
    end
  end
end
