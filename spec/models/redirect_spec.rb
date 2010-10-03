require 'spec_helper'

describe 'Given an empty redirects table' do
  before(:each) do
    Redirect.delete_all
  end

  it 'redirects are unique' do
    lambda { Redirect.create!(:from_path => 'foo/bar', :to_path => '/') }.should_not raise_error

    redirect = Redirect.new(:from_path => 'foo/bar', :to_path => '/')

    redirect.should_not be_valid
    redirect.errors[:from_path].should == ['has already been taken']
  end
end

