require File.dirname(__FILE__) + '/../spec_helper'

context 'Given a new StaticSidebar' do
  setup { @sb = StaticSidebar.new }

  specify 'title should be Links' do
    @sb.title.should == 'Links'
  end

  specify 'body should be our default' do
    @sb.body.should == StaticSidebar::DEFAULT_TEXT
  end

  specify 'description should be set correctly' do
    @sb.description.should == 'Static content, like links to other sites, advertisements, or blog meta-information'
  end
end
