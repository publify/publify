require 'spec_helper'

describe GroupingController do

  describe "should set meta robots to noindex follow when" do
    it "tag controller and unindex_tags options is true" do
      Factory(:blog, :unindex_tags => true)
      controller.should_receive(:grouping_class).and_return(Tag)
      controller.send(:set_noindex).should be_true
    end
    it "category controller and unindex_categories optinos is true" do
      Factory(:blog, :unindex_categories => true)
      controller.should_receive(:grouping_class).exactly(2).times.and_return(Category)
      controller.send(:set_noindex).should be_true
    end
    it "page params not blank and unindex_tags and unindex_categories are set to false" do
      Factory(:blog, :unindex_categories => false, :unindex_tags => false)
      controller.should_receive(:grouping_class).exactly(2).times.and_return(Category)
      controller.send(:set_noindex, 1).should be_true
    end
  end
  describe "should not set meta robots to noindex follow when" do
    it "tag controller and unindex_tags options is false and page params nil" do
      Factory(:blog, :unindex_tags => false)
      controller.should_receive(:grouping_class).exactly(2).times.and_return(Tag)
      controller.send(:set_noindex).should be_false
    end
    it "categoriy controller and unindex_categories options is false and page params nil" do
      Factory(:blog, :unindex_categories => false)
      controller.should_receive(:grouping_class).exactly(2).times.and_return(Category)
      controller.send(:set_noindex).should be_false
    end
  end
end
