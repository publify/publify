require 'rails_helper'

describe Theme, type: :model do
  let(:blog) { build_stubbed :blog }
  let(:default_theme) { blog.current_theme }

  describe '#layout' do
    it 'returns "layouts/default.html" by default' do
      theme = Theme.new('test', 'test')
      expect(theme.layout('index')).to eq 'layouts/default.html'
    end

    # FIXME: Test pages layout
  end

  describe '#name' do
    it "returns the theme's name (default: bootstrap-2)" do
      expect(default_theme.name).to eq 'bootstrap-2'
    end
  end

  describe '#description' do
    it 'returns the contents of the corresponding markdown file' do
      expect(default_theme.description).to eq(
        File.open(::Rails.root.to_s + '/themes/bootstrap-2/about.markdown') { |f| f.read })
    end
  end

  describe '.theme_from_path' do
    it 'finds the correct theme' do
      expect(Theme.theme_from_path(::Rails.root.to_s + 'themes/bootstrap-2').name).
        to eq 'bootstrap-2'
    end
  end

  describe '.search_theme_path' do
    it 'finds directories containing an about.markdown file' do
      fake_blue_theme_dir = 'fake_blue_theme_dir'
      fake_red_theme_dir = 'fake_red_theme_dir'
      fake_bad_theme_dir = 'fake_bad_theme_dir'
      expect(Dir).to receive(:glob).and_return([fake_blue_theme_dir, fake_bad_theme_dir, fake_red_theme_dir])
      expect(File).to receive(:readable?).with(fake_blue_theme_dir + '/about.markdown').and_return(true)
      expect(File).to receive(:readable?).with(fake_bad_theme_dir + '/about.markdown').and_return(false)
      expect(File).to receive(:readable?).with(fake_red_theme_dir + '/about.markdown').and_return(true)
      expect(Theme.search_theme_directory).to eq %w(fake_blue_theme_dir fake_red_theme_dir)
    end
  end

  describe '.find_all' do
    let(:theme_directories) do
      Dir.glob(::Rails.root.to_s + '/themes/[a-zA-Z0-9]*').select do |file|
        File.readable? "#{file}/about.markdown"
      end
    end

    it 'finds all the installed themes' do
      expect(Theme.find_all.size).to eq theme_directories.size
    end
  end
end
