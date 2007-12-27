require File.dirname(__FILE__) + '/../../test_helper'
require 'admin/trackbacks_controller'

# Re-raise errors caught by the controller.
class Admin::TrackbacksController; def rescue_action(e) raise e end; end

class Admin::TrackbacksControllerTest < Test::Unit::TestCase
  fixtures :contents, :feedback, :users

  def setup
    @controller = Admin::TrackbacksController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @request.session = { :user_id => users(:tobi).id }
  end

  def test_index
    get :index, :article_id => 2
    assert_template 'list'
  end

  def test_list
    get :list, :article_id => 2
    assert_template 'list'
    assert_template_has 'trackbacks'
  end

  def test_show
    get :show, :id => feedback(:trackback1).id, :article_id => 2
    assert_template 'show'
    assert_template_has 'trackback'
    assert_valid assigns(:trackback)
  end

  def test_new
    get :new, :article_id => 2
    assert_template 'new'
    assert_template_has 'trackback'
  end

  def test_create
    num_trackbacks = Trackback.count

    post :new, :trackback => { 'title' => 'title', 'excerpt' => 'excerpt', 'blog_name' => 'blog_name', 'url' => 'url' }, :article_id => 2
    assert_response :redirect, :action => 'show'

    assert_equal num_trackbacks + 1, Trackback.count
  end

  def test_edit
    get :edit, :id => feedback(:trackback1).id, :article_id => 2
    assert_template 'edit'
    assert_template_has 'trackback'
    assert_valid assigns(:trackback)
  end

  def test_update
    post :edit, :id => feedback(:trackback1).id, :article_id => 2
    assert_response :redirect, :action => 'show', :id => feedback(:trackback1).id
  end

  def test_destroy
    assert_not_nil Trackback.find(feedback(:trackback1).id)

    get :destroy, :id => feedback(:trackback1).id, :article_id => 2
    assert_response :success

    post :destroy, :id => feedback(:trackback1).id, :article_id => 2
    assert_response :redirect, :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      trackback = Trackback.find(feedback(:trackback1).id)
    }
  end
end
