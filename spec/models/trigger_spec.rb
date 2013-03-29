require 'spec_helper'

describe Trigger do
  before(:each) do
    FactoryGirl.create :blog
    @page = FactoryGirl.create :page, published: false
  end

  it '.post_action should not fire immediately for future triggers' do
    @page.should_not be_published

    Trigger.post_action(Time.now + 2, @page, 'publish!')
    Trigger.count.should == 1
    Trigger.fire
    Trigger.count.should == 1

    @page.reload
    @page.should_not be_published

    # Stub Time.now to emulate sleep.
    t = Time.now
    Time.stub(:now).and_return(t + 5.seconds)
    Trigger.fire
    Trigger.count.should == 0

    @page.reload
    @page.should be_published
  end

  it '.post_action should fire immediately if the target time is <= now' do
    @page.should_not be_published

    Trigger.post_action(Time.now, @page, 'publish!')
    Trigger.count.should == 0

    @page.reload
    @page.should be_published
  end

end
