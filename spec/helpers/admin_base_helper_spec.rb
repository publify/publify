require File.dirname(__FILE__) + '/../spec_helper'

describe 'With the Admin::BaseHelper' do
  helper_name 'admin/base'

  it 'time_delta_from_now_in_words(time_in_the_future) should use "from now"' do
    time_delta_from_now_in_words(2.days.from_now).should == '2 days from now'
  end

  it 'time_delta_from_now_in_words(time_in_the_past) should use "ago"' do
    time_delta_from_now_in_words(2.days.ago).should == '2 days ago'
  end
end
