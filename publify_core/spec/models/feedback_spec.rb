# frozen_string_literal: true

require "rails_helper"

describe Feedback, type: :model do
  before { create(:blog) }

  describe ".change_state!" do
    it "respond to change_state!" do
      expect(described_class.new).to respond_to(:change_state!)
    end

    context "given a feedback with a spam state" do
      it "calls mark_as_ham!" do
        feedback = build(:spam_comment)
        expect(feedback.change_state!).to eq "ham"
        expect(feedback).to be_ham
      end
    end

    context "given a feedback with a ham state" do
      it "calls mark_as_spam!" do
        feedback = build(:ham_comment)
        expect(feedback.change_state!).to eq "spam"
        expect(feedback).to be_spam
      end
    end
  end

  describe "scopes" do
    describe "ham" do
      it "returns nothing when no ham" do
        create(:spam_comment)
        expect(described_class.ham).to be_empty
      end

      it "returns only ham" do
        create(:spam_comment)
        ham = create(:ham_comment)
        expect(described_class.ham).to eq [ham]
      end
    end

    describe "created_since" do
      let(:time) { 1.year.ago }

      it "returns nothing with no feedback" do
        create(:ham_comment, created_at: 2.years.ago)
        expect(described_class.created_since(time)).to be_empty
      end

      it "returns feedback when one created since last visit" do
        create(:ham_comment, created_at: 2.years.ago)
        feedback = create(:ham_comment, created_at: time + 2.hours)
        expect(described_class.created_since(time)).to eq [feedback]
      end
    end

    context "order by created at" do
      let(:now) { DateTime.new(2009, 12, 6, 14, 56).in_time_zone }

      describe "#paginated" do
        let!(:a_comment) { create(:comment, created_at: now) }
        let!(:an_other_comment) { create(:comment, created_at: now - 1.day) }

        it { expect(described_class.paginated(1, 3)).to eq([a_comment, an_other_comment]) }
        it { expect(described_class.paginated(2, 1)).to eq([an_other_comment]) }
        it { expect(described_class.paginated(1, 1)).to eq([a_comment]) }
      end

      describe "#presumed_ham" do
        let!(:presumed_ham_comment) { create(:presumed_ham_comment) }
        let!(:ham_comment) { create(:ham_comment) }

        it { expect(described_class.presumed_ham).to eq([presumed_ham_comment]) }
      end

      describe "#presumed_spam" do
        let!(:presumed_spam_comment) { create(:presumed_spam_comment) }
        let!(:ham_comment) { create(:ham_comment) }

        it { expect(described_class.presumed_spam).to eq([presumed_spam_comment]) }
      end

      describe "#spam" do
        let!(:spam_comment) { create(:spam_comment) }
        let!(:ham_comment) { create(:ham_comment) }

        it { expect(described_class.spam).to eq([spam_comment]) }
      end

      describe "#unapproved" do
        let!(:unapproved) { create(:unconfirmed_comment) }
        let!(:ham_comment) { create(:ham_comment) }

        it { expect(described_class.unapproved).to eq([unapproved]) }
      end
    end
  end

  describe "#report_as_ham" do
    let(:comment) { create(:comment) }
    let(:blog) { comment.blog }

    it "works if the blog has no akismet key" do
      comment.report_as_ham
    end

    it "works if the blog has an invalid akismet key" do
      verification = stub_request(:post, "https://rest.akismet.com/1.1/verify-key").
        to_return(status: 200, body: "invalid", headers: {})
      blog.sp_akismet_key = "hello!"
      blog.save!
      comment.report_as_ham
      expect(verification).to have_been_requested
    end

    it "works if the blog has a valid akismet key" do
      verification = stub_request(:post, "https://rest.akismet.com/1.1/verify-key").
        to_return(status: 200, body: "valid", headers: {})
      reporting = stub_request(:post, "https://hello!.rest.akismet.com/1.1/submit-ham").
        to_return(status: 200, body: "Thanks for making the web a better place.",
                  headers: {})
      blog.sp_akismet_key = "hello!"
      blog.save!
      comment.report_as_ham
      expect(verification).to have_been_requested
      expect(reporting).to have_been_requested
    end
  end

  describe "states" do
    before do
      create(:blog)
      @comment = create(:article).comments.build(author: "Piers", body: "Body")
    end

    it "test_ham_all_the_way" do
      class << @comment
        def classify
          :ham
        end
      end
      assert @comment.unclassified?
      @comment.classify_content
      assert @comment.published?
      @comment.save
      @comment = Comment.find(@comment.id)
      @comment.confirm_classification
      assert @comment.published?
    end

    it "test_spam_all_the_way" do
      class << @comment
        def classify
          :spam
        end
      end
      assert @comment.unclassified?
      @comment.classify_content
      assert !@comment.published?
      assert @comment.save
      assert !@comment.published?
      @comment = Comment.find(@comment.id)
      @comment.confirm_classification
      assert !@comment.published?
    end

    it "test_presumed_spam_marked_as_ham" do
      @comment[:state] = "presumed_spam"
      @comment.mark_as_ham
      assert @comment.published?
    end

    it "test_presumed_ham_marked_as_spam" do
      @comment[:state] = "presumed_ham"
      @comment.mark_as_spam
      assert !@comment.published?
    end
  end

  describe "validations" do
    let(:feedback) { described_class.new }

    it "requires title to not be too long" do
      expect(feedback).to validate_length_of(:title).is_at_most(255)
    end

    it "requires author to not be too long" do
      expect(feedback).to validate_length_of(:author).is_at_most(255)
    end

    it "requires email to not be too long" do
      expect(feedback).to validate_length_of(:email).is_at_most(255)
    end

    it "requires url to not be too long" do
      expect(feedback).to validate_length_of(:url).is_at_most(255)
    end

    it "requires ip to not be too long" do
      expect(feedback).to validate_length_of(:ip).is_at_most(40)
    end

    it "requires blog_name to not be too long" do
      expect(feedback).to validate_length_of(:blog_name).is_at_most(255)
    end

    it "requires user_agent to not be too long" do
      expect(feedback).to validate_length_of(:user_agent).is_at_most(255)
    end

    it "requires text_filter_name to not be too long" do
      expect(feedback).to validate_length_of(:text_filter_name).is_at_most(255)
    end
  end
end
