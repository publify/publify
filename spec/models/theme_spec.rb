require File.dirname(__FILE__) + '/../spec_helper'

context 'Given a new test theme' do
  setup do
    @theme = Theme.new("test", "test")
  end

  specify 'layout path should be "../../themes/test/layouts/default"'  do
    @theme.layout.should == "../../themes/test/layouts/default"
  end
end

context 'Given a the default theme' do
  setup do
    @theme = Blog.new.current_theme
  end

  specify 'theme should be azure' do
    @theme.name.should == 'azure'
  end

  specify 'theme description should be correct' do
    @theme.description.should ==
      File.open(RAILS_ROOT + '/themes/azure/about.markdown') {|f| f.read}
  end

  specify 'theme_from_path should find the correct theme' do
    Theme.theme_from_path(RAILS_ROOT + 'themes/azure').name.should == 'azure'
    Theme.theme_from_path(RAILS_ROOT + 'themes/scribbish').name.should == 'scribbish'
  end

  specify '#search_theme_path finds the right things' do
    Theme.should_receive(:themes_root).and_return(RAILS_ROOT + '/test/mocks/themes')
    Theme.search_theme_directory.collect{|t| File.basename(t)}.sort.should ==
      %w{ 123-numbers-in-path CamelCaseDirectory azure i-have-special-chars }
  end

  specify 'find_all finds all the installed themes' do
    Theme.find_all.collect{|t| t.name}.should_include(@theme.name)
    Theme.find_all.size.should ==
      Dir.glob(RAILS_ROOT + '/themes/[a-zA-Z0-9]*').select do |file|
        File.readable? "#{file}/about.markdown"
      end.size
  end
end
