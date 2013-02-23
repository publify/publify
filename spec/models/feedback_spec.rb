require 'spec_helper'

describe Feedback do
  before do
    FactoryGirl.create(:blog)
  end

  describe ".change_state!" do
    it "respond to change_state!" do
      Feedback.new.should respond_to(:change_state!)
    end

    context "given a feedback with a spam state" do
      it "calls mark_as_ham!" do
        feedback = FactoryGirl.build(:spam_comment)
        feedback.should_receive(:mark_as_ham)
        feedback.should_receive(:save!)
        feedback.change_state!.should eq "ham"
      end
    end

    context "given a feedback with a ham state" do
      it "calls mark_as_spam!" do
        feedback = FactoryGirl.build(:ham_comment)
        feedback.should_receive(:mark_as_spam)
        feedback.should_receive(:save!)
        feedback.change_state!.should eq "spam"
      end
    end
  end

  describe "scopes" do
    describe "ham" do
      it "returns nothing when no ham" do
        FactoryGirl.create(:spam_comment)
        Feedback.ham.should be_empty
      end

      it "returns only ham" do
        FactoryGirl.create(:spam_comment)
        ham = FactoryGirl.create(:ham_comment)
        Feedback.ham.should eq [ham]
      end
    end

    describe "published_since" do
      let(:time) { DateTime.new(2011, 11, 1, 13, 45) }
      it "returns nothing with no feedback" do
        FactoryGirl.create(:ham_comment)
        Feedback.published_since(time).should be_empty
      end

      it "returns feedback when one published since last visit" do
        FactoryGirl.create(:ham_comment)
        feedback = FactoryGirl.create(:ham_comment, published_at: time + 2.hours)
        Feedback.published_since(time).should eq [feedback]
      end
    end
  end
end
