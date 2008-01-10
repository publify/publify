require File.dirname(__FILE__) + '/../spec_helper'

describe "Given the first Blog fixture" do
  before(:each) { @blog = blogs(:default) }

  it ":blog_name == 'test blog'" do
    @blog.blog_name.should == 'test blog'
  end

  it "values boolify like Perl" do
    {"0 but true" => true, "" => false,
      "false" => false, 1 => true, 0 => false,
     nil => false, 'f' => false }.each do |value, expected|
      @blog.sp_global = value
      @blog.sp_global.should == expected
    end
  end

  it "blog.url_for does the right thing" do
    @blog.url_for(:controller => 'articles', :action => 'read', :id => 1).should == 'http://myblog.net/articles/read/1'
  end

  it "blog has one sidebar" do
    @blog.should have(1).sidebars
  end
end
