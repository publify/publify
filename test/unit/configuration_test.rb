require File.dirname(__FILE__) + '/../test_helper'

class ConfigurationTest < Test::Unit::TestCase
  fixtures :settings

  def setup
    @config = Configuration.new
  end

  def test_fixtures
    assert_equal "tobi", @config["login"]
    assert_equal "whatever", @config["password"]
  end
  
  def test_reload
    Setting.create("name" => "test", "value" => "test")
    assert_nil @config['test']
    @config.reload
    assert_equal "test", @config['test']
  end
  
  def test_is_ok
    Setting.destroy_all "value = 1"
    @config.reload
    assert ! @config.is_ok?
    
    Setting.create("name" => "default_allow_pings", "value" => "whatever")
    Setting.create("name" => "default_allow_comments", "value" => "whatever")
    Setting.create("name" => "password", "value" => "whatever")
    Setting.create("name" => "login", "value" => "whatever")
    Setting.create("name" => "blog_name", "value" => "whatever")
    Setting.create("name" => "sp_article_auto_close", "value" => "whatever")
    Setting.create("name" => "sp_url_limit", "value" => "whatever")
    Setting.create("name" => "sp_global", "value" => "1")
    
    @config.reload
    
    assert @config.is_ok?  
  end
  
end