require File.dirname(__FILE__) + '/../spec_helper'

describe 'Given the fixture :first_page' do
  before(:each) do
    @page = contents(:first_page)
  end

  it '#permalink_url should be: http://myblog.net/pages/page_one' do
    @page.permalink_url.should == 'http://myblog.net/pages/page_one'
  end

  it '#edit_url should be: http://myblog.net/admin/pages/edit/<page_id>' do
    @page.edit_url.should == "http://myblog.net/admin/pages/edit/#{@page.id}"
  end

  it '#delete_url should work too' do
    @page.delete_url.should == "http://myblog.net/admin/pages/destroy/#{@page.id}"
  end

  it 'Pages cannot have the same name' do
    Page.new(:name => @page.name, :body => @page.body, :title => @page.title).should_not be_valid
    Page.new(:name => @page.name, :body => 'body', :title => 'title').should_not be_valid
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

describe "ValidPageHelper", :shared => true do
  def valid_attributes
    { :name => 'name', :title => 'title', :body => 'body'}
  end
end

describe 'Given no pages' do
  it_should_behave_like "ValidPageHelper"

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
    @page.errors.on(:name).should == "can't be blank"
    @page.name = 'somename'
    @page.should be_valid
  end

  it 'A page is invalid without a title' do
    @page.attributes = valid_attributes.except(:title)
    @page.should_not be_valid
    @page.errors.on(:title).should == "can't be blank"
    @page.title = 'sometitle'
    @page.should be_valid
  end

  it 'A page is invalid without a body' do
    @page.attributes = valid_attributes.except(:body)
    @page.should_not be_valid
    @page.errors.on(:body).should == "can't be blank"
    @page.body = 'somebody'
    @page.should be_valid
  end
end

describe 'Given a valid page' do
  it_should_behave_like "ValidPageHelper"

  it 'default filter should be fetched from the blog' do
    blog = mock_model(Blog)
    Blog.stub!(:find).and_return(blog)
    textfilter = mock_model(TextFilter)
    textfilter.stub!(:to_text_filter).and_return(textfilter)

    blog.should_receive(:text_filter).and_return(textfilter)
    @page = Page.new(valid_attributes.merge(:blog => blog))
    @page.default_text_filter.should == textfilter
  end
end
