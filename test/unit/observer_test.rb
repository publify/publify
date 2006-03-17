require File.dirname(__FILE__) + '/../test_helper'

require 'http_mock'

class ObserverTest < Test::Unit::TestCase
  fixtures :contents, :blogs, :articles_tags, :tags,
           :resources, :categories, :articles_categories

  def reset_observer
    @informant = nil
    @symbol    = nil
  end

  def setup
    reset_observer
  end

  def update(informant, symbol)
    @informant = informant
    @symbol = symbol
  end

  def test_simple_observation
    art = Article.find(contents(:article1).id)
    assert art.add_observer(self)
    art.changed
    art.notify_observers(art, :test)

    assert_equal art.id, @informant.id
    assert_equal :test, @symbol
  end

  def test_content_observation
    contents(:article1).add_observer(self)
    contents(:article1).body = 'A new body'

    assert_equal contents(:article1), @informant
    assert_equal :body, @symbol
  end
end
