ENV["RAILS_ENV"] = "test"

# Expand the path to environment so that Ruby does not load it multiple times
# File.expand_path can be removed if Ruby 1.9 is in use.
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'application'

require 'test/unit'
require 'active_record/fixtures'
require 'action_controller/test_process'
require 'action_web_service/test_invoke'
require 'breakpoint'

# Set salt to 'change-me' because thats what the fixtures assume. 
User.salt = 'change-me'

Test::Unit::TestCase.fixture_path = File.dirname(__FILE__) + "/fixtures/"

class Test::Unit::TestCase
  # Turn these off to use instantiated fixtures.  This is really only useful with MySQL with
  # MyISAM tables.
  self.use_transactional_fixtures = true
  #self.use_instantiated_fixtures  = false

  def create_fixtures(*table_names)
    Fixtures.create_fixtures(File.dirname(__FILE__) + "/fixtures", table_names)
  end
  
  def assert_xml(xml)
    assert_nothing_raised do
      assert REXML::Document.new(xml)
    end
  end

  # Add more helper methods to be used by all tests here...
  def find_tag_in(source, conditions)
    require_html_scanner
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