require File.dirname(__FILE__) + '/../spec_helper'

describe 'Given a new test theme' do
  before(:each) do
    @theme = Theme.new("test", "test")
  end

  it 'layout path should be "../../themes/test/layouts/default"'  do
    @theme.layout.should == "../../themes/test/layouts/default"
  end
end

describe 'Given a the default theme' do
  before(:each) do
    @theme = Blog.default.current_theme
  end

  it 'theme should be standard_issue' do
    @theme.name.should == 'standard_issue'
  end

  it 'theme description should be correct' do
    @theme.description.should ==
      File.open(RAILS_ROOT + '/themes/standard_issue/about.markdown') {|f| f.read}
  end

  it 'theme_from_path should find the correct theme' do
    Theme.theme_from_path(RAILS_ROOT + 'themes/standard_issue').name.should == 'standard_issue'
    Theme.theme_from_path(RAILS_ROOT + 'themes/azure').name.should == 'azure'
    Theme.theme_from_path(RAILS_ROOT + 'themes/scribbish').name.should == 'scribbish'
  end

  it '#search_theme_path finds the right things' do
    Theme.should_receive(:themes_root).and_return(RAILS_ROOT + '/test/mocks/themes')
    Theme.search_theme_directory.collect{|t| File.basename(t)}.sort.should ==
      %w{ 123-numbers-in-path CamelCaseDirectory i-have-special-chars standard_issue }
  end

  it 'find_all finds all the installed themes' do
    Theme.find_all.collect{|t| t.name}.should include(@theme.name)
    Theme.find_all.size.should ==
      Dir.glob(RAILS_ROOT + '/themes/[a-zA-Z0-9]*').select do |file|
        File.readable? "#{file}/about.markdown"
      end.size
  end
end
