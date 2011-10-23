# coding: utf-8
require 'spec_helper'

describe 'Given the fixture :first_page' do
  before(:each) do
    Factory(:blog)
    @page = Factory(:page)
  end

  describe "#permalink_url" do
    subject { @page.permalink_url }
    it { should == 'http://myblog.net/pages/page_one' }
  end

  describe "url" do
    before do
      @base_url = 'http://myblog.net/admin/pages/'
    end

    it '#edit_url should be: http://myblog.net/admin/pages/edit/<page_id>' do
      @page.edit_url.should == "#{@base_url}edit/#{@page.id}"
    end

    it '#delete_url should work too' do
      @page.delete_url.should == "#{@base_url}destroy/#{@page.id}"
    end
  end

  it 'Pages cannot have the same name' do
    Page.new(:name => @page.name, :body => @page.body, :title => @page.title).should_not be_valid
    Page.new(:name => @page.name, :body => 'body', :title => 'title').should_not be_valid
  end
  
  it "should give a satanized title" do
    page = Factory.build(:page, :title => 'title with accents éèà')
    page.satanized_title.should == 'title-with-accents-eea'
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
    { :name => 'name', :title => 'title', :body => 'body'}
  end

  before(:each) do
    Page.delete_all
    @page = Page.new
  end

  it 'An empty page is invalid' do
    @page.should_not be_valid
  end

  it 'A page is valid with name, title and body' do
    @page.attributes = valid_attributes
    @page.should be_valid
  end

  it 'A page is invalid without a name' do
    @page.attributes = valid_attributes.except(:name)
    @page.should_not be_valid
    @page.errors[:name].should == ["can't be blank"]
    @page.name = 'somename'
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
end

describe 'Given a valid page' do
  it 'default filter should be fetched from the blog' do
    Factory(:blog)
    @page = Page.new()
    @page.default_text_filter.name.should == Blog.default.text_filter
  end
end
