require File.dirname(__FILE__) + '/../../test_helper'
require 'content_state/factory'

class ContentState::FactoryTest < Test::Unit::TestCase
  def test_correctly_derives_new_state
    assert_instance_of(ContentState::New,
                       ContentState::Factory.derived_from(MockContent.new(true)))
  end

  def test_correctly_derives_draft_state
    assert_instance_of(ContentState::Draft,
                       ContentState::Factory.derived_from(MockContent.new(false, nil, nil)))
  end

  def test_correctly_derives_publication_pending_state
    assert_instance_of(ContentState::PublicationPending,
                       ContentState::Factory.derived_from(MockContent.new(false, nil, 1.day.from_now)))
    assert_instance_of(ContentState::PublicationPending,
                       ContentState::Factory.derived_from(MockContent.new(true, true,
                                                                          1.hour.from_now)))

    assert_instance_of(ContentState::PublicationPending,
                       ContentState::Factory.derived_from(MockContent.new(true, false,
                                                                          1.hour.from_now)))
  end

  def test_correct_derives_published_state
    assert_instance_of(ContentState::Published,
                       ContentState::Factory.derived_from(MockContent.new(false, true,
                                                                          1.hour.ago)))
  end

  def test_cant_make_state_directly
    assert_raise(NoMethodError) do
      ContentState::Base.new
    end
  end

  def test_write_new_state
    content = MockContent.new(true)

    assert ContentState::New.instance.serialize_on(content)

    assert_equal false, content.published?
    assert_nil content.published_at
  end

  def test_write_publication_pending_state
    content = MockContent.new(true, true, 1.hour.from_now)
    assert ContentState::PublicationPending.instance.serialize_on(content)
    assert_equal false, content.published?
    assert content.published_at > Time.now
  end

  def test_write_draft_state
    content = MockContent.new(true, nil, nil)
    assert ContentState::Draft.instance.serialize_on(content)
    assert_equal false, content.published
    assert_nil content.published_at
  end

  def test_write_just_published_state
    content = MockContent.new(true, nil, nil)
    assert ContentState::JustPublished.instance.serialize_on(content)
    assert_equal true, content.published
    assert content.published_at <= Time.now

    published_at = 10.minutes.ago
    content = MockContent.new(true, nil, published_at)
    assert ContentState::JustPublished.instance.serialize_on(content)
    assert_equal true, content.published
    assert_equal published_at, content.published_at
  end

  def test_write_published_state
    content = MockContent.new
    assert ContentState::Published.instance.serialize_on(content)
  end

  class MockContent < Struct.new(:new_record, :published, :published_at)
    alias_method :new_record?, :new_record
    alias_method :published?, :published
  end
end
