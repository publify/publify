require File.dirname(__FILE__) + '/../../test_helper'

class FeedbackStatesTest < Test::Unit::TestCase
  fixtures :blogs, :contents, :articles_tags, :tags, :resources,
    :categories, :articles_categories, :users, :notifications, :text_filters

  def setup
    @comment = Article.find(:first).comments.build(:author => 'Piers',
                                                   :body => 'Body')
  end

  def test_ham_all_the_way
    assert_state ContentState::Unclassified
    assert   @comment.published?
    assert   @comment.just_published?
    assert   @comment.just_changed_published_status?
    assert   @comment.save
    assert   @comment.just_changed_published_status?
    assert   @comment.just_published?
    @comment.reload
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
    assert_state ContentState::Unclassified
    assert ! @comment.published?
    assert ! @comment.just_published?
    assert ! @comment.just_changed_published_status?
    assert   @comment.save
    assert ! @comment.published?
    assert ! @comment.just_published?
    assert ! @comment.just_changed_published_status?
    @comment.reload
    assert ! @comment.just_changed_published_status?
    assert ! @comment.just_published?
    @comment.confirm_classification
    assert ! @comment.published?
    assert ! @comment.just_published?
    assert ! @comment.just_changed_published_status?
  end

  def test_presumed_spam_marked_as_ham
    @comment.state = ContentState::PresumedSpam.instance
    @comment.mark_as_ham
    assert @comment.published?
    assert @comment.just_published?
    assert @comment.just_changed_published_status?
  end

  def test_presumed_ham_marked_as_spam
    @comment.state = ContentState::PresumedHam.instance
    @comment.mark_as_spam
    assert ! @comment.published?
    assert ! @comment.just_published?
    assert   @comment.just_changed_published_status?
  end

  def assert_state(state)
    assert_instance_of state, @comment.state
  end
end
