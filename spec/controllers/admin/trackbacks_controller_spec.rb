require File.dirname(__FILE__) + '/../../../test/test_helper'
require File.dirname(__FILE__) + '/../../spec_helper'
require 'admin/trackbacks_controller'

# Re-raise errors caught by the controller.
class Admin::TrackbacksController; def rescue_action(e) raise e end; end

describe Admin::TrackbacksController do
  before do
    request.session = { :user_id => users(:tobi).id }
    @art_id = contents(:article2).id
  end

  def test_index
    get :index, :article_id => @art_id
    assert_template 'list'
  end

  def test_list
    get :list, :article_id => @art_id
    assert_template 'list'
    assert_template_has 'trackbacks'
  end

  def test_show
    get :show, :id => feedback(:trackback1).id, :article_id => @art_id
    assert_template 'show'
    assert_template_has 'trackback'
    assert_valid assigns(:trackback)
  end

  def test_new
    get :new, :article_id => @art_id
    assert_template 'new'
    assert_template_has 'trackback'
  end

  def test_create
    num_trackbacks = Trackback.count

    post :new, :trackback => { 'title' => 'title', 'excerpt' => 'excerpt', 'blog_name' => 'blog_name', 'url' => 'url' }, :article_id => @art_id
    assert_response :redirect, :action => 'show'

    assert_equal num_trackbacks + 1, Trackback.count
  end

  def test_edit
    get :edit, :id => feedback(:trackback1).id, :article_id => @art_id
    assert_template 'edit'
    assert_template_has 'trackback'
    assert_valid assigns(:trackback)
  end

  def test_update
    post :edit, :id => feedback(:trackback1).id, :article_id => @art_id
    assert_response :redirect, :action => 'show', :id => feedback(:trackback1).id
  end

  def test_destroy
    assert_not_nil Trackback.find(feedback(:trackback1).id)

    get :destroy, :id => feedback(:trackback1).id, :article_id => @art_id
    assert_response :success

    post :destroy, :id => feedback(:trackback1).id, :article_id => @art_id
    assert_response :redirect, :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      trackback = Trackback.find(feedback(:trackback1).id)
    }
  end
end
