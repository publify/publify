require File.dirname(__FILE__) + '/../spec_helper'

describe CacheInformation do

  def cache_information(options={})
    CacheInformation.new({:path => '/index.html'}.merge(options))
  end

  it 'should have path attribute' do
    CacheInformation.new.should respond_to(:path)
  end

  it 'should be valid' do
    cache_information.should be_valid
  end

  it 'should not save without path' do
    cache_information(:path => nil).should_not be_valid
  end

  it 'should have path unique' do
    cache_information.save
    cache_information.should_not be_valid
  end

  it 'should destroy file in path when destroy' do
    file_path = create_file_in_spec_public_cache_directory('index.html')
    CacheInformation.create!(:path => '/index.html').destroy
    File.should_not be_exist(file_path)
  end

  it "should destroy himself if path doesn't exist" do
    CacheInformation.create!(:path => '/index.html').destroy
    CacheInformation.find_by_path('/index.html').should be_nil
  end

  it "should logged in warning the path if path doesn't exist" do
    Rails.logger.should_receive(:warn).with("path : /index.html no more exist")
    CacheInformation.create!(:path => '/index.html').destroy
  end

end
