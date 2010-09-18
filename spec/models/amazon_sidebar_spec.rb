require 'spec_helper'

describe "Given a brand new AmazonSidebar" do
  before(:each) do
    @sidebar = AmazonSidebar.new
  end

  it "title should be 'Cited books'" do
    @sidebar.title.should == 'Cited books'
  end

  it "associate_id should be 'justasummary-20'" do
    @sidebar.associate_id.should == 'justasummary-20'
  end

  it "maxlinks should be 4" do
    @sidebar.maxlinks.should == 4
  end

  it "description should be 'Adds sidebar links...'" do
    @sidebar.description.should ==
      "Adds sidebar links to any amazon books linked in the body of the page"
  end

  it "sidebar should be valid" do
    @sidebar.should be_valid
  end
end

describe "With no amazon sidebars" do
  it "hash initialization should set attributes correctly" do
    sb = AmazonSidebar.new(:title => 'Books',
                           :associate_id => 'justasummary-21',
                           :maxlinks => 3)
    sb.should be_valid
    sb.title.should        == 'Books'
    sb.associate_id.should == 'justasummary-21'
    sb.maxlinks.should     ==  3
  end
end
