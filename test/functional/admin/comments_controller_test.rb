require File.dirname(__FILE__) + '/../../test_helper'
require 'admin/comments_controller'
require 'dns_mock'

# Re-raise errors caught by the controller.
class Admin::CommentsController; def rescue_action(e) raise e end; end

class Admin::CommentsControllerTest < Test::Unit::TestCase
  fixtures :contents, :users

  def setup
    @controller = Admin::CommentsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @request.session = { :user => users(:tobi) }
  end

  def test_index
    get :index, :article_id => 2
    assert_rendered_file 'list'
  end

  def test_list
    get :list, :article_id => 2
    assert_rendered_file 'list'
    assert_template_has 'comments'
  end

  def test_show
    get :show, :id => 5, :article_id => 2
    assert_rendered_file 'show'
    assert_template_has 'comment'
    assert_valid_record 'comment'
  end

  def test_new
    get :new, :article_id => 2
    assert_rendered_file 'new'
    assert_template_has 'comment'
  end

  def test_create
    num_comments = Comment.count

    post(:new, :comment => { 'author' => 'author', 'body' => 'body' },
               :article_id => 2)
    assert_redirected_to :action => 'show'

    assert_equal num_comments + 1, Comment.count
  end

  def test_edit
    get :edit, :id => 5, :article_id => 2
    assert_rendered_file 'edit'
    assert_template_has 'comment'
    assert_valid_record 'comment'
  end

  def test_update
    post :edit, :id => 5, :article_id => 2
    assert_redirected_to :action => 'show', :id => 5
  end

  def test_destroy
    assert_not_nil Comment.find(5)

    get :destroy, :id => 5, :article_id => 2
    assert_success

    post :destroy, :id => 5, :article_id => 2
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      comment = Comment.find(5)
    }
  end
end
