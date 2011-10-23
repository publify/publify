# coding: utf-8
require 'spec_helper'

describe PostType do
  before(:each) do
    Factory(:blog)
  end
  
  describe 'Given a new post type' do
    it 'should give a valid post type' do
      PostType.create(:name => 'foo').should be_valid
    end
   
   it 'should have a sanitized permalink' do
     @pt = PostType.create(:name => "Un joli PostType Accentué")
     @pt.permalink.should == 'un-joli-posttype-accentue'
   end
    
   it 'should have a sanitized permalink with a' do
     @pt = PostType.create(:name => "Un joli PostType à Accentuer")
     @pt.permalink.should == 'un-joli-posttype-a-accentuer'
   end
  end
  
  it 'post types are unique' do
    lambda {PostType.create!(:name => 'test')}.should_not raise_error
    test_type = PostType.new(:name => 'test')
    test_type.should_not be_valid
    test_type.errors[:name].should == ['has already been taken']
  end
  
end
