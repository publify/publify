require 'spec_helper'

describe "A blog" do
  before(:each) {
    RouteCache.clear
    @blog = Blog.new
  }

  it "values boolify like Perl" do
    {"0 but true" => true, "" => false,
      "false" => false, 1 => true, 0 => false,
     nil => false, 'f' => false }.each do |value, expected|
      @blog.sp_global = value
      @blog.sp_global.should == expected
    end
  end

  describe "running in the host root" do
    before :each do
      @blog.base_url = 'http://myblog.net'
    end

    describe "blog.url_for" do
      describe "with a hash argument" do
        subject { @blog.url_for(:controller => 'categories', :action => 'show', :id => 1) }
        it { should == 'http://myblog.net/category/1' }
      end

      describe "with a hash argument with only_path" do
        subject { @blog.url_for(:controller => 'categories', :action => 'show', :id => 1, :only_path => true) }
        it { should == '/category/1' }
      end

      describe "with a string argument" do
        subject { @blog.url_for('category/1') }
        it { should == 'http://myblog.net/category/1' }
      end

      it "should return the correct URL for a string argument with only_path" do
        @blog.url_for('category/1', :only_path => true).should == '/category/1'
      end
    end
  end

  describe "running in a sub-URI" do
    before :each do
      @blog.base_url = 'http://myblog.net/sub-uri'
    end

    describe "blog.url_for" do
      it "should return the correct URL for a hash argument" do
        @blog.url_for(:controller => 'categories', :action => 'show',
                      :id => 1).should == 'http://myblog.net/sub-uri/category/1'
      end
      it "should return the correct URL for a hash argument with only_path" do
        @blog.url_for(:controller => 'categories', :action => 'show', :id => 1,
                     :only_path => true).should == '/sub-uri/category/1'
      end
      it "should return the correct URL for a string argument" do
        @blog.url_for('category/1'
                     ).should == 'http://myblog.net/sub-uri/category/1'
      end
      it "should return the correct URL for a string argument with only_path" do
        @blog.url_for('category/1',
                      :only_path => true).should == '/sub-uri/category/1'
      end
    end
  end
end

describe "The first blog" do
  before(:each) {
    @blog = Factory.create :blog
  }

  it "should be the only blog allowed" do
    Blog.new.should_not be_valid
  end
end

describe "The default blog" do
  it "should pick up updates after a cache clear" do
    Factory(:blog)
    b = Blog.default
    b.blog_name = "some other name"
    b.save
    c = Blog.default
    c.blog_name.should == "some other name"
  end
end

describe "Given no blogs, a new default blog" do
  before :each do
    @blog = Blog.new
  end

  it "should be valid after filling the title" do
    @blog.blog_name = "something not empty"
    @blog.should be_valid
  end

  it "should be valid without filling the title" do
    @blog.blog_name.should == "My Shiny Weblog!"
    @blog.should be_valid
  end

  it "should not be valid after setting an empty title" do
    @blog.blog_name = ""
    @blog.should_not be_valid
  end
end

describe "Valid permalink in blog" do

  before :each do
    @blog = Blog.new
  end

  ['foo', 'year', 'day', 'month', 'title', '%title', 'title%', '/year/month/day/title', '%title%.html.atom', '%title%.html.rss'].each do |permalink_type|
    it "not valid with #{permalink_type}" do
      @blog.permalink_format = permalink_type
      @blog.should_not be_valid
    end
  end

  ['%year%', '%day%', '%month%', '%title%', '%title%.html', '/hello/all/%year%/%title%', 'atom/%title%.html', 'ok/rss/%title%.html'].each do |permalink_type|
    it "should be valid with only #{permalink_type}" do
      @blog.permalink_format = permalink_type
      @blog.should be_valid
    end
  end

end
