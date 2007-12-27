require File.dirname(__FILE__) + '/../test_helper'

require 'content'
require 'article'

# Assumptions test? What's that then?
#
# Here's where we test assumptions about way Rails behaves that we
# rely on in the codebase. That way, if the Rails behaviour changes,
# we can catch the underlying cause here, which can save a good deal
# of bug chasing.

class Article
  def got_saved
    @saved
  end

  protected

  before_save :set_saved_var

  def set_saved_var
    @saved = true
  end
end

class AssumptionsTest < Test::Unit::TestCase

  # This only works in the case where the article caches the comment
  # counter. Because the counter_cache is 'invisible' to the model, it
  # could be argued that incrementing it shouldn't go triggering the
  # 'visible' save/update/whatever hooks in Activerecord. (Which would
  # be a shame, because we rely on it). So, we'll continue to check
  # that Rails does what we expect.

  def test_adding_a_comment_saves_the_article
    a = Article.new(:title => 'A title', :body => 'Some body')

    assert !a.got_saved
    assert  a.save
    assert  a.got_saved

    a = nil

    a = Article.find(:first)

    assert !a.got_saved

    c = Comment.new( :author => 'Piers Cawley', :body => 'A boring comment')

    a.comments << c
    assert a.got_saved
  end
end
