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

  describe ".remove" do
    context "with several existing triggers" do
      let!(:item) { create :content }
      let!(:other_item) { create :content }

      let!(:trigger_item_foo) {
        Trigger.create due_at: 1.day.from_now, pending_item: item, trigger_method: 'foo' }
      let!(:trigger_item_bar) {
        Trigger.create due_at: 1.day.from_now, pending_item: item, trigger_method: 'bar' }
      let!(:trigger_other_item_foo) {
        Trigger.create due_at: 1.day.from_now, pending_item: other_item, trigger_method: 'foo' }

      it "removes the trigger for the given item and condition" do
        Trigger.remove item, trigger_method: 'foo'
        Trigger.all.should =~ [trigger_item_bar, trigger_other_item_foo]
      end

      it "removes the triggers for the given item" do
        Trigger.remove item
        Trigger.all.should =~ [trigger_other_item_foo]
      end
    end
  end
end
