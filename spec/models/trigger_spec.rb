require File.dirname(__FILE__) + '/../spec_helper'

describe 'With the contents fixture' do
  before(:each) do
    @page = mock('fake_page')
    @page.stub!(:id).and_return(1)
    @page.stub!(:type).and_return('Page')
    @page.stub!(:new_record?).and_return(false)
    @page.stub!(:class).and_return(Page)
    Content.stub!(:find).and_return(@page)
    @current_utime = 1
    Time.stub!(:now).and_return { Time.at(@current_utime) }
  end

  def sleep(time_delta)
    @current_utime += time_delta
  end

  it '.post_action should not fire immediately for future triggers' do
    lambda do
      Trigger.post_action(Time.now + 2, @page, 'tickle')
      Trigger.count.should == 1
      Trigger.fire
      Trigger.count.should == 1
    end.should_not raise_error

    @page.should_receive(:tickle)
    sleep 2
    Trigger.fire
    Trigger.count.should == 0
  end

  it '.post_action should fire immediately if the target time is <= now' do
    @page.should_receive(:tickle)
    Trigger.post_action(Time.now, @page, 'tickle')
    Trigger.count.should == 0
  end

end
