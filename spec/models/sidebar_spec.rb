require 'spec_helper'

describe Sidebar do
  describe "#available_sidebars" do
    it "finds at least the standard sidebars" do
      assert Sidebar.available_sidebars.size >= 6
    end
  end

  describe "#find_all_visible" do
    before do
      AmazonSidebar.new(:active_position => 1).save
      AuthorsSidebar.new().save
    end

    it "returns only the sidebar with active position" do
      sidebars = Sidebar.find_all_visible
      sidebars.size.should == 1
      sidebars.first.class.should == AmazonSidebar
    end
  end

  describe "#find with an invalid sidebar in the database" do
    before do
      Sidebar.class_eval { set_inheritance_column :bogus }
      Sidebar.new(:type => "AmazonSidebar").save
      Sidebar.new(:type => "FooBarSidebar").save
      Sidebar.class_eval { set_inheritance_column :type }
    end

    it "skips the invalid active sidebar" do
      sidebars = Sidebar.find :all
      sidebars.size.should == 1
      sidebars.first.class.should == AmazonSidebar
    end
  end

  describe "#content_partial" do
    it "bases the partial name on the class name" do
      AmazonSidebar.new.content_partial.should == "/amazon_sidebar/content"
    end
  end
end
