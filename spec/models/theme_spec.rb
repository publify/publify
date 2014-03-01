require 'spec_helper'

describe Theme do
  let(:blog) { build_stubbed :blog }
  let(:default_theme) { blog.current_theme }

  describe '#layout' do
    it 'returns "layouts/default.html" by default' do
      theme = Theme.new("test", "test")
      theme.layout('index').should eq "layouts/default.html"
    end

    # FIXME: Test pages layout
  end

  describe '#name' do
    it "returns the theme's name (default: bootstrap)" do
      default_theme.name.should eq 'bootstrap'
    end
  end

  describe '#description' do
    it 'returns the contents of the corresponding markdown file' do
      default_theme.description.should eq(
        File.open(::Rails.root.to_s + '/themes/bootstrap/about.markdown') {|f| f.read})
    end
  end

  describe '.theme_from_path' do
    it 'finds the correct theme' do
      Theme.theme_from_path(::Rails.root.to_s + 'themes/bootstrap').name.
        should eq 'bootstrap'
    end
  end

  describe '.search_theme_path' do
    it 'finds directories containing an about.markdown file' do
      fake_blue_theme_dir = 'fake_blue_theme_dir'
      fake_red_theme_dir = 'fake_red_theme_dir'
      fake_bad_theme_dir = 'fake_bad_theme_dir'
      Dir.should_receive(:glob).and_return([fake_blue_theme_dir, fake_bad_theme_dir, fake_red_theme_dir])
      File.should_receive(:readable?).with(fake_blue_theme_dir + "/about.markdown").and_return(true)
      File.should_receive(:readable?).with(fake_bad_theme_dir + "/about.markdown").and_return(false)
      File.should_receive(:readable?).with(fake_red_theme_dir + "/about.markdown").and_return(true)
      Theme.search_theme_directory.should eq %w{ fake_blue_theme_dir fake_red_theme_dir }
    end
  end

  describe '.find_all' do
    let(:theme_directories) do
      Dir.glob(::Rails.root.to_s + '/themes/[a-zA-Z0-9]*').select do |file|
        File.readable? "#{file}/about.markdown"
      end
    end

    it 'finds all the installed themes' do
      Theme.find_all.size.should eq theme_directories.size
    end
  end
end
