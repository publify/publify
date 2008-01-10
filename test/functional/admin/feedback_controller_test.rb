require File.dirname(__FILE__) + '/../../test_helper'
require 'admin/feedback_controller'
require 'comment'
require 'trackback'

# Re-raise errors caught by the controller.
class Admin::FeedbackController; def rescue_action(e) raise e end; end

class Admin::FeedbackControllerTest < Test::Unit::TestCase
  def setup
    @controller = Admin::FeedbackController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.session = { :user_id => users(:tobi).id }
  end

  def test_index
    get :index

    assert_response :success
    assert_template 'list'
    assert_equal Feedback.count, assigns(:feedback).size
  end

  def test_list_unconfirmed
    get :index, :confirmed => 'f'

    assert_response :success
    assert_template 'list'

    assert_equal(Feedback.count(:conditions => ['blog_id = ? AND status_confirmed = ?',
                                                blogs(:default).id,               false]),
                 assigns(:feedback).size)

  end

  def test_list_spam
    get :index, :published => 'f'

    assert_response :success
    assert_template 'list'

    assert_equal(Feedback.count(:conditions => ['blog_id = ? AND published = ?',
                                                blogs(:default).id,        false]),
                 assigns(:feedback).size)
  end

  def test_list_unconfirmed_spam
    get :index, :published => 'f', :confirmed => 'f'

    assert_response :success
    assert_template 'list'

    assert_equal(Feedback.count(:conditions => ['blog_id = ? AND published = ? AND status_confirmed = ?',
                                                blogs(:default).id,        false,                   false]),
                 assigns(:feedback).size)
  end

end
