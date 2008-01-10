require File.dirname(__FILE__) + '/../test_helper'

class AmazonSidebarTest < Test::Unit::TestCase
  def test_creation
    assert_kind_of Sidebar, AmazonSidebar.new
  end

  def test_default_title
    assert_equal 'Cited books',     AmazonSidebar.new.title
  end

  def test_default_associate_id
    assert_equal 'justasummary-20', AmazonSidebar.new.associate_id
  end

  def test_default_maxlinks
    assert_equal 4,                 AmazonSidebar.new.maxlinks
  end

  def test_description
    assert_equal "Adds sidebar links to any amazon books linked in the body of the page",
      AmazonSidebar.description
  end

  def test_initialization_with_hash
    sb = AmazonSidebar.new(:title => 'Books',
                           :associate_id => 'justasummary-21',
                           :maxlinks => 3)
    assert sb
    assert_equal 'Books',           sb.title
    assert_equal 'justasummary-21', sb.associate_id
    assert_equal 3,                 sb.maxlinks
  end
end
