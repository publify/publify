require 'spec_helper'

describe 'Given a new test theme' do
  before(:each) do
    @theme = Theme.new("test", "test")
  end

  it 'layout path should be "#{::Rails.root.to_s}/themes/test/layouts/default.html.erb"'  do
    @theme.layout('index').should == "#{::Rails.root.to_s}/themes/test/layouts/default.html.erb"
  end
end

describe 'Given the default theme' do
  before(:each) do
    Factory(:blog)
    @theme = Blog.default.current_theme
  end

  it 'theme should be typographic' do
    @theme.name.should == 'typographic'
  end

  it 'theme description should be correct' do
    @theme.description.should ==
      File.open(::Rails.root.to_s + '/themes/typographic/about.markdown') {|f| f.read}
  end

  it 'theme_from_path should find the correct theme' do
    Theme.theme_from_path(::Rails.root.to_s + 'themes/typographic').name.should == 'typographic'
    Theme.theme_from_path(::Rails.root.to_s + 'themes/scribbish').name.should == 'scribbish'
  end

  it '#search_theme_path finds the right things' do
    Theme.should_receive(:themes_root).and_return(::Rails.root.to_s + '/test/mocks/themes')
    Theme.search_theme_directory.collect{|t| File.basename(t)}.sort.should ==
      %w{ 123-numbers-in-path CamelCaseDirectory i-have-special-chars typographic }
  end

  it 'find_all finds all the installed themes' do
    Theme.find_all.collect{|t| t.name}.should include(@theme.name)
    Theme.find_all.size.should ==
      Dir.glob(::Rails.root.to_s + '/themes/[a-zA-Z0-9]*').select do |file|
        File.readable? "#{file}/about.markdown"
      end.size
  end
end
