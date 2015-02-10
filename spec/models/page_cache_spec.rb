require 'rails_helper'

describe PageCache, type: :model do
  describe 'PageCache#self.sweep_all' do
    before(:each) do
      all_files = ['/index.html', '/articles.rss', '/sitemap.xml']
      @all_paths = []
      all_files.each do |path|
        @all_paths << create_file_in_spec_public_cache_directory(path)
      end
    end

    it 'should destroy all file in cache directory with path' do
      PageCache.sweep_all
      @all_paths.each do |path|
        expect(File).not_to be_exist(path)
      end
    end
  end
end
