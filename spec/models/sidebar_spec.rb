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
      Sidebar.class_eval { self.inheritance_column = :bogus }
      Sidebar.new(:type => "AmazonSidebar").save
      Sidebar.new(:type => "FooBarSidebar").save
      Sidebar.class_eval { self.inheritance_column = :type }
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

  describe "::setting" do
    let(:dummy_sidebar) do
      Class.new(Sidebar) do
        setting :foo, "default-foo"
      end
    end

    it "creates a reader method with default value on instances" do
      dummy = dummy_sidebar.new
      dummy.foo.should eq "default-foo"
    end

    it "creates a writer method on instances" do
      dummy = dummy_sidebar.new
      dummy.foo = "adjusted-foo"
      dummy.foo.should eq "adjusted-foo"
    end

    it "provides the default value to instances created earlier" do
      dummy = dummy_sidebar.new

      dummy_sidebar.instance_eval do
        setting :bar, "default-bar"
      end

      dummy.config.should_not have_key("bar")
      dummy.bar.should eq "default-bar"
    end
  end
end
