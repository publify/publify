require File.dirname(__FILE__) + '/../../test_helper'
require 'admin/feedback_controller'

# Re-raise errors caught by the controller.
class Admin::FeedbackController; def rescue_action(e) raise e end; end

class Admin::FeedbackControllerTest < Test::Unit::TestCase
  fixtures :contents, :users, :resources, :text_filters,
           :blogs, :articles_categories

  def setup
    @controller = Admin::FeedbackController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.session = { :user => users(:tobi) }
  end

  def test_index
    get :index
    
    assert_success
    assert_rendered_file 'list'
  end
end
