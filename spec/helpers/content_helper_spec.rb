require File.dirname(__FILE__) + '/../spec_helper'

describe ContentHelper, 'calc_distributed_class' do
  include ContentHelper

  it 'should behave as specified in the old test_calc_distributed_class_basic ' do
    calc_distributed_class(0, 0, "prefix", 5, 15).should == 'prefix5'

    (0..10).each do |article|
      calc_distributed_class(article, 10, "prefix", 0, 10).should == "prefix#{article}"
    end

    (0..20).each do |article|
      calc_distributed_class(article, 20, "prefix", 0, 10).should == "prefix#{(article/2).to_i}"
    end

    (0..5).each do |article|
      calc_distributed_class(article, 5, "prefix", 0, 10).should == "prefix#{(article*2).to_i}"
    end
  end

  it "should behave like the old test_calc_distributed_class_offset" do
    (0..10).each do |article|
      calc_distributed_class(article, 10, "prefix", 6, 16).should == "prefix#{article+6}"
    end
  end

end
