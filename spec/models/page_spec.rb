require File.dirname(__FILE__) + '/../spec_helper'

context 'Given the fixture :first_page' do
  fixtures :contents, :blogs

  setup { @page = contents(:first_page) }

  specify '#permalink_url should be: http://myblog.net/pages/page_one' do
    @page.permalink_url.should == 'http://myblog.net/pages/page_one'
  end

  specify '#edit_url should be: http://myblog.net/admin/pages/edit/9' do
    @page.edit_url.should == 'http://myblog.net/admin/pages/edit/9'
  end

  specify '#delete_url should work too' do
    @page.delete_url.should == 'http://myblog.net/admin/pages/destroy/9'
  end

  specify 'Pages cannot have the same name' do
    Page.new(:name => @page.name, :body => @page.body, :title => @page.title).should_not_be_valid
    Page.new(:name => @page.name, :body => 'body', :title => 'title').should_not_be_valid
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

module ValidPageHelper
  def valid_attributes
    { :name => 'name', :title => 'title', :body => 'body'}
  end
end

context 'Given no pages' do
  include ValidPageHelper

  setup { @page = Page.new }

  specify 'An empty page is invalid' do
    @page.should_not_be_valid
  end

  specify 'A page is valid with name, title and body' do
    @page.attributes = valid_attributes
    @page.should_be_valid
  end

  specify 'A page is invalid without a name' do
    @page.attributes = valid_attributes.except(:name)
    @page.should_not_be_valid
    @page.errors.on(:name).should == "can't be blank"
    @page.name = 'somename'
    @page.should_be_valid
  end

  specify 'A page is invalid without a title' do
    @page.attributes = valid_attributes.except(:title)
    @page.should_not_be_valid
    @page.errors.on(:title).should == "can't be blank"
    @page.title = 'sometitle'
    @page.should_be_valid
  end

  specify 'A page is invalid without a body' do
    @page.attributes = valid_attributes.except(:body)
    @page.should_not_be_valid
    @page.errors.on(:body).should == "can't be blank"
    @page.body = 'somebody'
    @page.should_be_valid
  end
end

context 'Given a valid page' do
  include ValidPageHelper
  setup { @page = Page.new(valid_attributes) }

  specify 'default filter should be textile' do
    @page.default_text_filter.name.should == 'textile'
  end
end
