require File.dirname(__FILE__) + '/../../../../test/test_helper'
require 'tiny_mce'

class TestController
  def self.helper(s) s; end
end

class TinyMCEController < ApplicationController
  uses_tiny_mce :only => [:new, :edit],
                :options => {:mode => 'advanced'}
  
  def new
    render :nothing => true
  end
  
  def edit
    render :nothing => true
  end
  
  def show
    render :nothing => true
  end
end

class TinyMceTest < Test::Unit::TestCase
  def setup
    @controller = TinyMCEController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end
  
  def test_include_exposes_tinymce_methods
    @controller = TestController.new
    assert !@controller.class.respond_to?(:uses_tiny_mce)
    assert !TestController.respond_to?(:uses_tiny_mce)
    TestController.send(:include, TinyMCE)
    assert TestController.respond_to?(:uses_tiny_mce)
    assert @controller.class.respond_to?(:uses_tiny_mce)  
  end
  
  def test_plugin_includes_tiny_mce_module_on_action_controller
    assert ApplicationController.respond_to?(:uses_tiny_mce)    
  end
  
  def test_uses_text_editor_is_available_as_alias
    assert ApplicationController.respond_to?(:uses_text_editor)
  end
  
  def test_uses_tiny_mce_with_only_options_sets_instance_variable_to_true_for_new
    get :new, :context => 'www'
    assert_response :success
    assert assigns(:uses_tiny_mce)
  end
  
  def test_uses_tiny_mce_with_options_sets_instance_variable_to_hash_for_new
    get :new, :context => 'www'
    assert_response :success
    assert assigns(:tiny_mce_options)
    assert assigns(:tiny_mce_options).kind_of?(Hash)
    assert assigns(:tiny_mce_options).include?(:mode)
  end
  
  def test_uses_tiny_mce_with_only_options_does_not_set_instance_variable_for_show
    get :show, :context => 'www'
    assert_response :success
    assert_nil assigns(:uses_tiny_mce)
  end
  
  def test_tiny_mce_option_validator
    assert_equal 121, TinyMCE::OptionValidator.options.size
    assert TinyMCE::OptionValidator.options.include?('mode')
    assert TinyMCE::OptionValidator.options.include?('theme')
    assert TinyMCE::OptionValidator.valid?(:submit_patch)
    assert TinyMCE::OptionValidator.valid?('submit_patch')
    assert TinyMCE::OptionValidator.valid?('theme_advanced_disable')
    assert !TinyMCE::OptionValidator.valid?('a_fake_option')
    assert !TinyMCE::OptionValidator.valid?(:wrong_again)
  end
  
  def test_tiny_mce_option_validator_for_plugin_options
    assert !TinyMCE::OptionValidator.valid?(:paste_auto_cleanup_on_paste)
    TinyMCE::OptionValidator.plugins = %w{paste}
    assert TinyMCE::OptionValidator.valid?(:paste_auto_cleanup_on_paste)
  end
end
