require File.dirname(__FILE__) + '/../spec_helper'

context "Given a brand new AmazonSidebar" do
  setup do
    @sidebar = AmazonSidebar.new
  end

  specify "title should be 'Cited books'" do
    @sidebar.title.should == 'Cited books'
  end

  specify "associate_id should be 'justasummary-20'" do
    @sidebar.associate_id.should == 'justasummary-20'
  end

  specify "maxlinks should be 4" do
    @sidebar.maxlinks.should == 4
  end

  specify "description should be 'Adds sidebar links...'" do
    @sidebar.description.should ==
      "Adds sidebar links to any amazon books linked in the body of the page"
  end

  specify "sidebar should be valid" do
    @sidebar.should_be_valid
  end
end

context "With no amazon sidebars" do
  specify "hash initialization should set attributes correctly" do
    sb = AmazonSidebar.new(:title => 'Books',
                           :associate_id => 'justasummary-21',
                           :maxlinks => 3)
    sb.should_be_valid
    sb.title.should        == 'Books'
    sb.associate_id.should == 'justasummary-21'
    sb.maxlinks.should     ==  3
  end
end
