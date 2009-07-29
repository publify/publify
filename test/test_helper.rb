ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'
require 'action_web_service/test_invoke'
require 'flexmock'

$TESTING = true

User.salt = 'change-me'

class ActiveSupport::TestCase
  self.use_transactional_fixtures = true

  # Instantiated fixtures are slow, but give you @david where you otherwise would need people(:david)
  self.use_instantiated_fixtures  = false

  fixtures %w{ blacklist_patterns blogs categories categorizations contents
               feedback notifications page_caches profiles redirects resources sidebars
               tags text_filters triggers users }

  def run(result)
    yield(STARTED, name)
    @_result = result
    begin
      setup
      __send__(@method_name)
    rescue Test::Unit::AssertionFailedError => e
      add_failure(e.message, e.backtrace)
     rescue StandardError, ScriptError
      add_error($!)
    ensure
      begin
        teardown
      rescue Test::Unit::AssertionFailedError => e
        add_failure(e.message, e.backtrace)
      rescue StandardError, ScriptError
        add_error($!)
      end
    end
    result.add_run
    yield(FINISHED, name)
  end


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

  def this_blog
    Blog.default || Blog.create!
  end

  def assert_template_has(key=nil, message=nil)
    msg = build_message(message, "<?> is not a template object", key)
    assert_block(msg) { @response.has_template_object?(key) }
  end

  def assert_template_has_no(key=nil, message=nil)
    msg = build_message(message, "<?> is a template object <?>",
                                  key,         @response.template_objects[key])
    assert_block(msg) { !@response.has_template_object?(key) }
  end

  def assert_session_has(key=nil, message=nil)
    msg = build_message(message, "<?> is not in the session <?>",
                                  key,                @response.session)
    assert_block(msg) { @response.has_session_object?(key) }
  end

  def assert_session_has_no(key=nil, message=nil)
    msg = build_message(message, "<?> is in the session <?>",
                                  key,         @response.session)
    assert_block(msg) { !@response.has_session_object?(key) }
  end

  def assert_invalid_column_on_record(key = nil, columns = "", message = nil) #:nodoc:
    record = find_record_in_template(key)
    record.send(:validate)

    cols = glue_columns(columns)
    cols.delete_if { |col| record.errors.invalid?(col) }
    msg = build_message(message, "Active Record has valid columns <?>)", cols.join(",") )
    assert_block(msg) { cols.empty? }
  end

  def glue_columns(columns)
    cols = []
    cols << columns if columns.class == String
    cols += columns if columns.class == Array
    cols
  end

  def find_record_in_template(key = nil)
    assert_not_nil assigns(key)
    record = @response.template_objects[key]

    assert_not_nil(record)
    assert_kind_of ActiveRecord::Base, record

    return record
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
