require 'spec_helper'

describe 'Given a new StaticSidebar' do
  before(:each) { @sb = StaticSidebar.new }

  it 'title should be Links' do
    @sb.title.should == 'Links'
  end

  it 'body should be our default' do
    @sb.body.should == StaticSidebar::DEFAULT_TEXT
  end

  it 'description should be set correctly' do
    @sb.description.should == 'Static content, like links to other sites, advertisements, or blog meta-information'
  end
end
