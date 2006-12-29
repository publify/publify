require File.dirname(__FILE__) + '/../spec_helper'

context 'Given an empty redirects table' do
  setup do
    Redirect.delete_all
  end

  specify 'redirects are unique' do
    lambda { Redirect.create!(:from_path => 'foo/bar', :to_path => '/') }.should_not_raise

    redirect = Redirect.new(:from_path => 'foo/bar', :to_path => '/')

    redirect.should_not_be_valid
    redirect.errors.on(:from_path).should == 'has already been taken'
  end
end

