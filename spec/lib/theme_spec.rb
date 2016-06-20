require 'rails_helper'

describe Theme, type: :model do
  let(:blog) { build_stubbed :blog }
  let(:default_theme) { blog.current_theme }

  describe '#layout' do
    it 'returns "layouts/default" by default' do
      theme = Theme.new('test', 'test')
      expect(theme.layout('index')).to eq 'layouts/default'
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
        File.open(::Rails.root.to_s + '/themes/bootstrap-2/about.markdown', &:read)
      )
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

    it 'includes the default theme' do
      expect(Theme.find_all.map(&:name)).to include 'bootstrap-2'
    end
  end
end
