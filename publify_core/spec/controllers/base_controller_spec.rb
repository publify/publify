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

describe BaseController, type: :controller do
  it 'safely caches a page' do
    define_spec_public_cache_directory
    file_path = path_for_file_in_spec_public_cache_directory('/test.html')
    File.delete file_path if File.exist? file_path
    expect(File).not_to be_exist(file_path)

    BaseController.perform_caching = true
    BaseController.cache_page 'test', '/test'
    expect(File).to be_exist(file_path)

    BaseController.perform_caching = false
    File.delete(file_path)
  end
end
