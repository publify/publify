require File.dirname(__FILE__) + '/../spec_helper'

describe 'The application controller' do
  controller_name :application
  it 'safely caches a page' do
    define_spec_public_cache_directory
    ApplicationController.perform_caching = true
    ApplicationController.cache_page 'test', '/test'
    file_path = path_for_file_in_spec_public_cache_directory('/test.html')
    File.should be_exist(file_path)
    ApplicationController.perform_caching = false
  end
end

