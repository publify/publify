require File.dirname(__FILE__) + '/../spec_helper'

describe "a valid Article" do
  before(:each) do
    @a = Article.new(:title => 'Test article', :body => 'body',
                     :author => mock_model(User), :blog => mock_model(Blog))
  end

  it "should be valid" do
    @a.should be_valid
  end

  it "should cast #published = '0' to false" do
    @a.published = '0'
    @a.published.should == false
  end
end
