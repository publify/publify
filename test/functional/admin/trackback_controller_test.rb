require File.dirname(__FILE__) + '/../../test_helper'
require 'admin/trackback_controller'

# Re-raise errors caught by the controller.
class Admin::TrackbackController; def rescue_action(e) raise e end; end

class Admin::TrackbackControllerTest < Test::Unit::TestCase
  fixtures :articles, :trackbacks, :users

  def setup
    @controller = Admin::TrackbackController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    
    @request.session = { :user => @tobi }
    @request.request_parameters[:article_id] = 2
  end

  def test_index
    get :index
    assert_rendered_file 'list'
  end

  def test_list
    get :list
    assert_rendered_file 'list'
    assert_template_has 'trackbacks'
  end

  def test_show
    get :show, 'id' => 1
    assert_rendered_file 'show'
    assert_template_has 'trackback'
    assert_valid_record 'trackback'
  end

  def test_new
    get :new
    assert_rendered_file 'new'
    assert_template_has 'trackback'
  end

  def test_create
    num_trackbacks = Trackback.find_all.size

    post :new, 'trackback' => { 'title' => 'title', 'excerpt' => 'excerpt', 'blog_name' => 'blog_name', 'url' => 'url' }
    assert_redirected_to :action => 'show'

    assert_equal num_trackbacks + 1, Trackback.find_all.size
  end

  def test_edit
    get :edit, 'id' => 1
    assert_rendered_file 'edit'
    assert_template_has 'trackback'
    assert_valid_record 'trackback'
  end

  def test_update
    post :edit, 'id' => 1
    assert_redirected_to :action => 'show', :id => 1
  end

  def test_destroy
    assert_not_nil Trackback.find(1)

    get :destroy, 'id' => 1
    assert_success
    
    post :destroy, 'id' => 1
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      trackback = Trackback.find(1)
    }
  end
end
