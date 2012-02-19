# coding: utf-8
require 'spec_helper'

describe Sanitizable, " an object with this module" do

  it "should respond to #remove_accents" do
    Object.new.extend(Sanitizable).should respond_to("remove_accents")
  end

   it 'should have a sanitized name attribute' do
     object = Object.new 
     object.extend(Sanitizable)
     object.remove_accents('Un joli nom accentué').should == 'un joli nom accentue'
   end
end

