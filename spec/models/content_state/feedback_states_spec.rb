require File.dirname(__FILE__) + '/../../spec_helper'

describe 'FeedbackStates from Test::Unit' do
  before(:each) do
    @comment = contents(:article1).comments.build(:author => 'Piers',
                                                  :body => 'Body')
  end

  def test_ham_all_the_way
    assert @comment.unclassified?
    assert   @comment.published?
    assert   @comment.just_published?
    assert   @comment.just_changed_published_status?
    assert   @comment.save
    assert   @comment.just_changed_published_status?
    assert   @comment.just_published?
    @comment = Comment.find(@comment.id)
    assert ! @comment.just_changed_published_status?
    assert ! @comment.just_published?
    @comment.confirm_classification
    assert   @comment.published?
    assert ! @comment.just_published?
    assert ! @comment.just_changed_published_status?
  end

  def test_spam_all_the_way
    class << @comment
      def classify
        :spam
      end
    end
    assert @comment.unclassified?
    assert ! @comment.published?
    assert ! @comment.just_published?
    assert ! @comment.just_changed_published_status?
    assert   @comment.save
    assert ! @comment.published?
    assert ! @comment.just_published?
    assert ! @comment.just_changed_published_status?
    @comment = Comment.find(@comment.id)
    assert ! @comment.just_changed_published_status?
    assert ! @comment.just_published?
    @comment.confirm_classification
    assert ! @comment.published?
    assert ! @comment.just_published?
    assert ! @comment.just_changed_published_status?
  end

  def test_presumed_spam_marked_as_ham
    @comment[:state] = 'presumed_spam'
    @comment.mark_as_ham
    assert @comment.published?
    assert @comment.just_published?
    assert @comment.just_changed_published_status?
  end

  def test_presumed_ham_marked_as_spam
    @comment[:state] = 'presumed_ham'
    @comment.mark_as_spam
    assert ! @comment.published?
    assert ! @comment.just_published?
    assert   @comment.just_changed_published_status?
  end
end
