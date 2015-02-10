require 'rails_helper'

describe ApplicationController, type: :controller do
  it 'safely caches a page' do
    define_spec_public_cache_directory
    file_path = path_for_file_in_spec_public_cache_directory('/test.html')
    File.delete file_path if File.exist? file_path
    expect(File).not_to be_exist(file_path)

    ApplicationController.perform_caching = true
    ApplicationController.cache_page 'test', '/test'
    expect(File).to be_exist(file_path)

    ApplicationController.perform_caching = false
    File.delete(file_path)
  end
end
