# coding: utf-8
require 'spec_helper'

describe Page do
  describe "#initialize" do
    it "accepts a settings field in its parameter hash" do
      Page.new({"password" => 'foo'})
    end
  end
end

describe "Testing redirects" do
  it "a new published page gets a redirect" do
    FactoryGirl.create(:blog)
    a = Page.create(:title => "Some title", :body => "some text", :published => true)
    a.should be_valid
    a.redirects.first.should_not be_nil
    a.redirects.first.to_path.should == a.permalink_url
  end

  it "a new unpublished page should not get a redirect" do 
    FactoryGirl.create(:blog)
    a = Page.create(:title => "Some title", :body => "some text", :published => true)
    a = Page.create(:title => "Another title", :body => "some text", :published => false)
    a.redirects.first.should be_nil
  end

  it "Changin a published article permalink url should only change the to redirection" do
    FactoryGirl.create(:blog)
    a = Page.create(:title => "Third title", :body => "some text", :published => true)
    a.should be_valid
    a.redirects.first.should_not be_nil
    a.redirects.first.to_path.should == a.permalink_url
    r  = a.redirects.first.from_path

    a.name = "some-new-permalink"
    a.save
    a.redirects.first.should_not be_nil
    a.redirects.first.to_path.should == a.permalink_url
    a.redirects.first.from_path.should == r
  end
end

describe 'Given the fixture :first_page' do
  before(:each) do
    FactoryGirl.create(:blog)
    @page = FactoryGirl.create(:page)
  end

  describe "#permalink_url" do
    subject { @page.permalink_url }
    it { should == 'http://myblog.net/pages/page_one' }
  end

  it 'Pages cannot have the same name' do
    Page.new(:name => @page.name, :body => @page.body, :title => @page.title).should_not be_valid
    Page.new(:name => @page.name, :body => 'body', :title => 'title').should_not be_valid
  end
  
  it "should give a sanitized title" do
    page = FactoryGirl.build(:page, :title => 'title with accents éèà')
    page.title.to_permalink.should == 'title-with-accents-eea'
  end
end

class Hash
  def except(*keys)
    self.reject { |k,v| keys.include? k.to_sym }
  end

  def only(*keys)
    self.dup.reject { |k, v| !keys.include? k.to_sym }
  end
end

describe 'Given no pages' do
  def valid_attributes
    { :title => 'title', :body => 'body'}
  end

  before(:each) do
    Page.delete_all
    @page = Page.new
  end

  it 'An empty page is invalid' do
    @page.should_not be_valid
  end

  it 'A page is valid with a title and body' do
    @page.attributes = valid_attributes
    @page.should be_valid
  end

  it 'A page is invalid without a title' do
    @page.attributes = valid_attributes.except(:title)
    @page.should_not be_valid
    @page.errors[:title].should == ["can't be blank"]
    @page.title = 'sometitle'
    @page.should be_valid
  end

  it 'A page is invalid without a body' do
    @page.attributes = valid_attributes.except(:body)
    @page.should_not be_valid
    @page.errors[:body].should == ["can't be blank"]
    @page.body = 'somebody'
    @page.should be_valid
  end
  
  it "should use sanitize title to set page name" do
    @page.attributes = valid_attributes.except(:title)
    @page.title = 'title with accents éèà'
    @page.should be_valid
    @page.save
    @page.name.should == "title-with-accents-eea"
  end
  
end

describe 'Given a valid page' do
  it 'default filter should be fetched from the blog' do
    FactoryGirl.create(:blog)
    @page = Page.new()
    @page.default_text_filter.name.should == Blog.default.text_filter
  end
end
