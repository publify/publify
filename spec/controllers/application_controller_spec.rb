require 'spec_helper'

describe ApplicationController do
  it 'safely caches a page' do
    define_spec_public_cache_directory
    file_path = path_for_file_in_spec_public_cache_directory('/test.html')
    File.delete file_path if File.exists? file_path
    File.should_not be_exist(file_path)

    ApplicationController.perform_caching = true
    ApplicationController.cache_page 'test', '/test'
    File.should be_exist(file_path)

    ApplicationController.perform_caching = false
    File.delete(file_path)
  end
end

