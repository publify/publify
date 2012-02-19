require 'spec_helper'

describe Blog do
  describe "#initialize" do
    it "accepts a settings field in its parameter hash" do
      Blog.new({"blog_name" => 'foo'})
    end
  end
end

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

  ['','/sub-uri'].each do |sub_url|
    describe "when running in with http://myblog.net#{sub_url}" do

      before :each do
        @base_url = "http://myblog.net#{sub_url}"
        @blog.base_url = @base_url 
      end

      [true, false].each do |only_path|
        describe "blog.url_for" do
          describe "with a hash argument and only_path = #{only_path}" do
            subject { @blog.url_for(:controller => 'categories', :action => 'show', :id => 1, :only_path => only_path) }
            it { should == "#{only_path ? sub_url : @base_url}/category/1" }
          end

          describe "with a string argument and only_path = #{only_path}" do
            subject { @blog.url_for('category/1', :only_path => only_path) }
            it { should == "#{only_path ? sub_url : @base_url}/category/1" }
          end
        end
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

  def set_permalink permalink
    @blog.permalink_format = permalink
  end

  ['foo', 'year', 'day', 'month', 'title', '%title', 'title%', '/year/month/day/title',
    '%year%', '%day%', '%month%', '%title%.html.atom', '%title%.html.rss'].each do |permalink_type|
    it "not valid with #{permalink_type}" do
      set_permalink permalink_type
      @blog.should_not be_valid
    end
    end

  ['%title%', '%title%.html', '/hello/all/%year%/%title%', 'atom/%title%.html', 'ok/rss/%title%.html'].each do |permalink_type|
    it "should be valid with only #{permalink_type}" do
      set_permalink permalink_type
      @blog.should be_valid
    end
  end

  it "should not be valid without %title% in" do
    @blog.permalink_format = '/toto/%year%/%month/%day%'
    @blog.should_not be_valid
  end

end
