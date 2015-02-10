require 'rails_helper'

describe Trigger, type: :model do
  before(:each) do
    FactoryGirl.create :blog
    @page = FactoryGirl.create :page, published: false
  end

  it '.post_action should not fire immediately for future triggers' do
    expect(@page).not_to be_published

    Trigger.post_action(Time.now + 2, @page, 'publish!')
    expect(Trigger.count).to eq(1)
    Trigger.fire
    expect(Trigger.count).to eq(1)

    @page.reload
    expect(@page).not_to be_published

    # Stub Time.now to emulate sleep.
    t = Time.now
    allow(Time).to receive(:now).and_return(t + 5.seconds)
    Trigger.fire
    expect(Trigger.count).to eq(0)

    @page.reload
    expect(@page).to be_published
  end

  it '.post_action should fire immediately if the target time is <= now' do
    expect(@page).not_to be_published

    Trigger.post_action(Time.now, @page, 'publish!')
    expect(Trigger.count).to eq(0)

    @page.reload
    expect(@page).to be_published
  end

  describe '.remove' do
    context 'with several existing triggers' do
      let!(:item) { create :content }
      let!(:other_item) { create :content }

      let!(:trigger_item_foo) do
        Trigger.create due_at: 1.day.from_now, pending_item: item, trigger_method: 'foo'
      end
      let!(:trigger_item_bar) do
        Trigger.create due_at: 1.day.from_now, pending_item: item, trigger_method: 'bar'
      end
      let!(:trigger_other_item_foo) do
        Trigger.create due_at: 1.day.from_now, pending_item: other_item, trigger_method: 'foo'
      end

      it 'removes the trigger for the given item and condition' do
        Trigger.remove item, trigger_method: 'foo'
        expect(Trigger.all).to match_array([trigger_item_bar, trigger_other_item_foo])
      end

      it 'removes the triggers for the given item' do
        Trigger.remove item
        expect(Trigger.all).to match_array([trigger_other_item_foo])
      end
    end
  end
end
