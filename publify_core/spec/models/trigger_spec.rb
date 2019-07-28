# frozen_string_literal: true

require "rails_helper"
require "timecop"

describe Trigger, type: :model do
  describe ".post_action" do
    before do
      create :blog
      @page = create :page, state: "draft"
      expect(@page).not_to be_published
    end

    it "does not fire immediately for future triggers" do
      described_class.post_action(2.seconds.from_now, @page, "publish!")
      expect(described_class.count).to eq(1)
      described_class.fire
      expect(described_class.count).to eq(1)

      @page.reload
      expect(@page).not_to be_published

      Timecop.freeze(4.seconds.from_now) do
        described_class.fire
      end

      expect(described_class.count).to eq(0)

      @page.reload
      expect(@page).to be_published
    end

    it "fires immediately if the target time is <= now" do
      described_class.post_action(Time.zone.now, @page, "publish!")
      expect(described_class.count).to eq(0)

      @page.reload
      expect(@page).to be_published
    end
  end

  describe ".remove" do
    context "with several existing triggers" do
      let!(:item) { create :content }
      let!(:other_item) { create :content }

      let!(:trigger_item_foo) do
        described_class.create due_at: 1.day.from_now, pending_item: item, trigger_method: "foo"
      end
      let!(:trigger_item_bar) do
        described_class.create due_at: 1.day.from_now, pending_item: item, trigger_method: "bar"
      end
      let!(:trigger_other_item_foo) do
        described_class.create due_at: 1.day.from_now, pending_item: other_item, trigger_method: "foo"
      end

      it "removes the trigger for the given item and condition" do
        described_class.remove item, trigger_method: "foo"
        expect(described_class.all).to match_array([trigger_item_bar, trigger_other_item_foo])
      end

      it "removes the triggers for the given item" do
        described_class.remove item
        expect(described_class.all).to match_array([trigger_other_item_foo])
      end
    end
  end
end
