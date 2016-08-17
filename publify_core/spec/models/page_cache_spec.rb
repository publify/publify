require 'rails_helper'

def define_spec_public_cache_directory
  spec_cache_dir = File.join(Rails.root, 'spec', 'public')
  unless File.exist? spec_cache_dir
    FileUtils.mkdir_p spec_cache_dir
  end
  ActionController::Base.page_cache_directory = spec_cache_dir
end

def path_for_file_in_spec_public_cache_directory(file)
  define_spec_public_cache_directory
  File.join(ActionController::Base.page_cache_directory, file)
end

def create_file_in_spec_public_cache_directory(file)
  file_path = path_for_file_in_spec_public_cache_directory(file)
  File.open(file_path, 'a').close
  file_path
end

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
