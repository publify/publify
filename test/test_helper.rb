ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'

$TESTING = true

User.salt = 'change-me'

class Test::Unit::TestCase
  # Turn off transactional fixtures if you're working with MyISAM tables in MySQL
  self.use_transactional_fixtures = true

  # Instantiated fixtures are slow, but give you @david where you otherwise would need people(:david)
  self.use_instantiated_fixtures  = false

  # Add more helper methods to be used by all tests here...
  def assert_xml(xml)
    assert_nothing_raised do
      assert REXML::Document.new(xml)
    end
  end

   # Add more helper methods to be used by all tests here...
  def find_tag_in(source, conditions)
    HTML::Document.new(source).find(conditions)
  end

  def assert_tag_in(source, opts)
    tag = find_tag_in(source, opts)
    assert tag, "expected tag, but no tag found matching #{opts.inspect} in:\n#{source.inspect}"
  end

  def assert_no_tag_in(source, opts)
    tag = find_tag_in(source, opts)
    assert !tag, "expected no tag, but tag found matching #{opts.inspect} in:\n#{source.inspect}"
  end

  def get_xpath(xpath)
    rexml = REXML::Document.new(@response.body)
    assert rexml

    REXML::XPath.match(rexml, xpath)
  end

  def assert_xpath(xpath, msg=nil)
    assert !(get_xpath(xpath).empty?), msg
  end

  def assert_not_xpath(xpath, msg=nil)
    assert get_xpath(xpath).empty?, msg
  end

  def this_blog
    Blog.default || Blog.create!
  end
end

# Extend HTML::Tag to understand URI matching
begin
  require 'html/document'
rescue LoadError
  require 'action_controller/vendor/html-scanner/html/document'
end
require 'uri'

class HTML::Tag
  private

  alias :match_condition_orig :match_condition unless private_method_defined? :match_condition_orig
  def match_condition(value, condition)
    case condition
      when URI
        compare_uri(URI.parse(value), condition.dup) rescue nil
      else
        match_condition_orig(value, condition)
    end
  end

  def compare_uri(value, condition)
    valQuery = value.query
    condQuery = condition.query
    value.query = nil
    condition.query = nil
    value == condition && compare_query(valQuery, condQuery)
  end

  def compare_query(value, condition)
    def create_query_hash(str)
      str.split('&').inject({}) do |h,v|
        key, value = v.split('=')
        h[key] = value
        h
      end
    end
    create_query_hash(value) == create_query_hash(condition)
  end
end
