# coding: utf-8
require 'spec_helper'

describe Satanizable, " an object with this module" do

  it "should respond to #satanized_title" do
    Object.new.extend(Satanizable).should respond_to("remove_accents")
  end

   it 'should have a sanitized name attribute' do
     object = Object.new 
     object.extend(Satanizable)
     object.remove_accents('Un joli nom accentué').should == 'un joli nom accentue'
   end
end

