require 'spec_helper'

describe 'Given a new test theme' do
  it 'layout path should be "#{::Rails.root.to_s}/themes/test/layouts/default.html.erb"'  do
    theme = Theme.new("test", "test")
    theme.layout('index').should == "#{::Rails.root.to_s}/themes/test/layouts/default.html.erb"
  end
end

describe 'Given the default theme' do
  before(:each) do
    FactoryGirl.create(:blog)
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
  end

  it '#search_theme_path finds the right things 2' do
    fake_blue_theme_dir = 'fake_blue_theme_dir'
    fake_red_theme_dir = 'fake_red_theme_dir'
    fake_bad_theme_dir = 'fake_bad_theme_dir'
    Dir.should_receive(:glob).and_return([fake_blue_theme_dir, fake_bad_theme_dir, fake_red_theme_dir])
    File.should_receive(:readable?).with(fake_blue_theme_dir + "/about.markdown").and_return(true)
    File.should_receive(:readable?).with(fake_bad_theme_dir + "/about.markdown").and_return(false)
    File.should_receive(:readable?).with(fake_red_theme_dir + "/about.markdown").and_return(true)
    Theme.search_theme_directory.should == %w{ fake_blue_theme_dir fake_red_theme_dir }
  end

  it 'find_all finds all the installed themes' do
    Theme.find_all.size.should ==
      Dir.glob(::Rails.root.to_s + '/themes/[a-zA-Z0-9]*').select do |file|
        File.readable? "#{file}/about.markdown"
      end.size
  end
end
