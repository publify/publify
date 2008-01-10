require File.dirname(__FILE__) + '/../../../test/test_helper'
require File.dirname(__FILE__) + '/../../spec_helper'
require 'admin/comments_controller'
require 'dns_mock'

# Re-raise errors caught by the controller.
class Admin::CommentsController; def rescue_action(e) raise e end; end

describe Admin::CommentsController do
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
    assert_template_has 'comments'
  end

  def test_show
    get :show, :id => feedback(:spam_comment).id, :article_id => @art_id
    assert_template 'show'
    assert_template_has 'comment'
    assert_valid @response.template_objects['comment']
  end

  def test_new
    get :new, :article_id => @art_id
    assert_template 'new'
    assert_template_has 'comment'
  end

  def test_create
    num_comments = Comment.count

    post(:new, :comment => { 'author' => 'author', 'body' => 'body' },
               :article_id => @art_id)
    assert_response :redirect, :action => 'show'

    assert_equal num_comments + 1, Comment.count
  end

  def test_edit
    get :edit, :id => feedback(:spam_comment).id, :article_id => @art_id
    assert_template 'edit'
    assert_template_has 'comment'
    assert_valid assigns(:comment)
  end

  def test_update
    post :edit, :id => feedback(:spam_comment).id, :article_id => @art_id
    assert_response :redirect, :action => 'show', :id => feedback(:spam_comment).id
  end

  def test_destroy
    assert_not_nil Comment.find(feedback(:spam_comment).id)

    get :destroy, :id => feedback(:spam_comment).id, :article_id => @art_id
    assert_response :success

    post :destroy, :id => feedback(:spam_comment).id, :article_id => @art_id
    assert_response :redirect, :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      comment = Comment.find(feedback(:spam_comment).id)
    }
  end
end
