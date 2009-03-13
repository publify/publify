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

  it "should be the only blog allowed" do
    Blog.new.should_not be_valid
  end
end

describe "The default blog" do
  it "should pick up updates after a cache clear" do
    a = Blog.default
    CachedModel.cache_reset
    b = blogs(:default)
    b.blog_name = "some other name"
    c = Blog.default
    c.blog_name.should == "some other name"
  end
end


describe "Given no blogs" do
  before(:each)  { Blog.destroy_all }

  it "should allow the creation of a valid default blog" do
    Blog.new.should be_valid
  end
end

describe "Valid permalink in blog" do

  before :each do
    @blog = blogs(:default)
  end

  ['foo', 'year', 'day', 'month', 'title', '%title', 'title%', '/year/month/day/title', '%title%.html.atom', '%title%.html.rss'].each do |permalink_type|
    it "not valid with #{permalink_type}" do
      assert_raise  ActiveRecord::RecordInvalid do
        @blog.permalink_format = permalink_type
      end
    end
  end

  ['%year%', '%day%', '%month%', '%title%', '%title%.html', '/hello/all/%year%/%title%', 'atom/%title%.html', 'ok/rss/%title%.html'].each do |permalink_type|
    it "should be valid with only #{permalink_type}" do
      assert_nothing_raised  ActiveRecord::RecordInvalid do
        @blog.permalink_format = permalink_type
      end
    end
  end

end
