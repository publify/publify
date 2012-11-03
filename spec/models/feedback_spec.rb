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
end
