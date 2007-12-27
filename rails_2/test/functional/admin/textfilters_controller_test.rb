require File.dirname(__FILE__) + '/../../test_helper'
require 'admin/textfilters_controller'

# Re-raise errors caught by the controller.
class Admin::TextfiltersController; def rescue_action(e) raise e end; end

class Admin::TextfiltersControllerTest < Test::Unit::TestCase
  fixtures :text_filters, :users

  def setup
    @controller = Admin::TextfiltersController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @request.session = { :user_id => users(:tobi).id }
  end

  def test_new_without_filters
    post :new, :textfilter => { :name => 'filterx',
      :description => 'Filter X', :markup => 'markdown' }
    assert_response :redirect, :action => 'show'
  end

  def test_edit_without_filters
    post :edit, :id => 1, :textfilter => { :name => 'filterx',
      :description => 'Filter X', :markup => 'markdown' }
    assert_response :redirect, :action => 'show'
  end
end
