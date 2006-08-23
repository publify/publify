require File.dirname(__FILE__) + '/../../test_helper'
require 'content_state/factory'

class ContentState::FactoryTest < Test::Unit::TestCase
  def test_correctly_builds_new_state
    [:new, 'new', 'content_state/new', 'New',
     'ContentState::New', nil].each do |memento|
      assert_instance_of(ContentState::New,
                         ContentState::Factory.new(memento))
    end
  end

  def test_correctly_builds_draft_state
    assert_instance_of(ContentState::Draft,
                       ContentState::Factory.new('draft'))
  end

  def test_correctly_builds_publication_pending_state
    assert_instance_of(ContentState::PublicationPending,
                       ContentState::Factory.new('publication_pending'))
  end

  def test_correct_builds_published_state
    assert_instance_of(ContentState::Published,
                       ContentState::Factory.new('published'))
  end

  def test_cant_make_state_directly
    assert_raise(NoMethodError) do
      ContentState::Base.new
    end
  end

  def test_write_new_state
    content = MockContent.new(true)

    ContentState::New.instance.enter_hook(content)

    assert_equal false, content.published?
    assert_nil content.published_at
  end

  def test_write_publication_pending_state
    content = MockContent.new(true, true, 1.hour.from_now)
    ContentState::PublicationPending.instance.enter_hook(content)
    assert_equal false, content.published?
    assert content.published_at > Time.now
  end

  def test_write_draft_state
    content = MockContent.new(true, nil, nil)
    ContentState::Draft.instance.enter_hook(content)
    assert_equal false, content.published
    assert_nil content.published_at
  end

  def test_write_just_published_state
    content = MockContent.new(true, nil, nil)
    ContentState::JustPublished.instance.enter_hook(content)
    assert_equal true, content.published
    assert content.published_at <= Time.now

    published_at = 10.minutes.ago
    content = MockContent.new(true, nil, published_at)
    ContentState::JustPublished.instance.enter_hook(content)
    assert_equal true, content.published
    assert_equal published_at, content.published_at
  end

  def test_write_published_state
    content = MockContent.new
    assert ContentState::Published.instance.enter_hook(content)
    assert_equal true, content.published
  end

  class MockContent < Struct.new(:new_record, :published, :published_at)
    alias_method :new_record?, :new_record
    alias_method :published?, :published

    def changed
      @changed = true
    end

    def changed?
      @changed
    end
  end
end
