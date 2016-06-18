require 'rails_helper'

describe Feedback, type: :model do
  before { create(:blog) }

  describe '.change_state!' do
    it 'respond to change_state!' do
      expect(Feedback.new).to respond_to(:change_state!)
    end

    context 'given a feedback with a spam state' do
      it 'calls mark_as_ham!' do
        feedback = FactoryGirl.build(:spam_comment)
        expect(feedback).to receive(:mark_as_ham)
        expect(feedback).to receive(:save!)
        expect(feedback.change_state!).to eq 'ham'
      end
    end

    context 'given a feedback with a ham state' do
      it 'calls mark_as_spam!' do
        feedback = FactoryGirl.build(:ham_comment)
        expect(feedback).to receive(:mark_as_spam)
        expect(feedback).to receive(:save!)
        expect(feedback.change_state!).to eq 'spam'
      end
    end
  end

  describe 'scopes' do
    describe '#comments' do
      context 'with 1 comments' do
        let!(:comment) { create(:comment) }
        it { expect(Feedback.comments).to eq([comment]) }
      end
    end

    describe '#trackbacks' do
      it { expect(Feedback).to respond_to(:trackbacks) }

      context 'with 1 Trackback' do
        let!(:trackback) { create(:trackback) }
        it { expect(Feedback.trackbacks).to eq([trackback]) }
      end
    end

    describe 'ham' do
      it 'returns nothing when no ham' do
        FactoryGirl.create(:spam_comment)
        expect(Feedback.ham).to be_empty
      end

      it 'returns only ham' do
        FactoryGirl.create(:spam_comment)
        ham = FactoryGirl.create(:ham_comment)
        expect(Feedback.ham).to eq [ham]
      end
    end

    describe 'published_since' do
      let(:time) { DateTime.new(2011, 11, 1, 13, 45) }
      it 'returns nothing with no feedback' do
        create(:ham_comment)
        expect(Feedback.published_since(time)).to be_empty
      end

      it 'returns feedback when one published since last visit' do
        FactoryGirl.create(:ham_comment)
        feedback = FactoryGirl.create(:ham_comment, published_at: time + 2.hours)
        expect(Feedback.published_since(time)).to eq [feedback]
      end
    end

    context 'order by created at' do
      let(:now) { DateTime.new(2009, 12, 6, 14, 56) }

      describe '#paginated' do
        let!(:a_comment) { create(:comment, created_at: now) }
        let!(:an_other_comment) { create(:comment, created_at: now - 1.day) }

        it { expect(Feedback.paginated(1, 3)).to eq([a_comment, an_other_comment]) }
        it { expect(Feedback.paginated(2, 1)).to eq([an_other_comment]) }
        it { expect(Feedback.paginated(1, 1)).to eq([a_comment]) }
      end

      describe '#presumed_ham' do
        let!(:presumed_ham_comment) { create(:presumed_ham_comment) }
        let!(:ham_comment) { create(:ham_comment) }

        it { expect(Feedback.presumed_ham).to eq([presumed_ham_comment]) }
      end

      describe '#presumed_spam' do
        let!(:presumed_spam_comment) { create(:presumed_spam_comment) }
        let!(:ham_comment) { create(:ham_comment) }

        it { expect(Feedback.presumed_spam).to eq([presumed_spam_comment]) }
      end

      describe '#spam' do
        let!(:spam_comment) { create(:spam_comment) }
        let!(:ham_comment) { create(:ham_comment) }
        it { expect(Feedback.spam).to eq([spam_comment]) }
      end

      describe '#unapproved' do
        let!(:unapproved) { create(:unconfirmed_comment) }
        let!(:ham_comment) { create(:ham_comment) }

        it { expect(Feedback.unapproved).to eq([unapproved]) }
      end
    end
  end

  describe '#from' do
    context 'with a comment' do
      let(:comment) { create(:comment) }
      it { expect(Feedback.from(:comments)).to eq([comment]) }
      it { expect(Feedback.from(:trackbacks)).to be_empty }
    end

    context 'with a trackback' do
      let(:trackback) { create(:trackback) }
      it { expect(Feedback.from(:comments)).to be_empty }
      it { expect(Feedback.from(:trackbacks)).to eq([trackback]) }
    end

    context 'with an article without published_comments' do
      let!(:article) { create(:article) }
      it { expect(Feedback.from(:comments, article.id)).to be_empty }
      it { expect(Feedback.from(:trackbacks, article.id)).to be_empty }
    end

    context 'with an article with published_comments' do
      let!(:article) { create(:article) }
      let!(:comment) { create(:comment, article: article) }
      it { expect(Feedback.from(:comments, article.id)).to eq([comment]) }
      it { expect(Feedback.from(:trackbacks, article.id)).to be_empty }
    end

    context 'with an article with published_trackbacks' do
      let!(:article) { create(:article) }
      let!(:trackback) { create(:trackback, article: article) }
      it { expect(Feedback.from(:comments, article.id)).to be_empty }
      it { expect(Feedback.from(:trackbacks, article.id)).to eq([trackback]) }
    end
  end
end
