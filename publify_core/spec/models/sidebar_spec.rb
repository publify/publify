# frozen_string_literal: true

require "rails_helper"

describe Sidebar, type: :model do
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
        sidebars = Sidebar.ordered_sidebars
        expect(sidebars).to eq([static_sidebar, search_sidebar])
      end
    end

    context "with an invalid sidebar in the database" do
      before do
        Sidebar.class_eval { self.inheritance_column = :bogus }
        Sidebar.new(type: "SearchSidebar", staged_position: 1, blog: blog).save
        Sidebar.new(type: "FooBarSidebar", staged_position: 2, blog: blog).save
        Sidebar.class_eval { self.inheritance_column = :type }
      end

      it "skips the invalid active sidebar" do
        sidebars = Sidebar.ordered_sidebars
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

  describe "::setting" do
    let(:dummy_sidebar) do
      Class.new(Sidebar) do
        setting :foo, "default-foo"
      end
    end

    it "creates a reader method with default value on instances" do
      dummy = dummy_sidebar.new
      expect(dummy.foo).to eq "default-foo"
    end

    it "creates a writer method on instances" do
      dummy = dummy_sidebar.new
      dummy.foo = "adjusted-foo"
      expect(dummy.foo).to eq "adjusted-foo"
    end

    it "provides the default value to instances created earlier" do
      dummy = dummy_sidebar.new

      dummy_sidebar.instance_eval do
        setting :bar, "default-bar"
      end

      expect(dummy.config).not_to have_key("bar")
      expect(dummy.bar).to eq "default-bar"
    end
  end
end
