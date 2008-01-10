require File.dirname(__FILE__) + '/../../../test/test_helper'
require File.dirname(__FILE__) + '/../../spec_helper'
require 'admin/pages_controller'

# Re-raise errors caught by the controller.
class Admin::PagesController; def rescue_action(e) raise e end; end

describe Admin::PagesController do
  before do
    request.session = { :user_id => users(:tobi).id }
  end

  def test_index
    get :index
    assert_response :success
    assert_template "list"
  end

  def test_list
    get :list
    assert_response :success
    assert_template "list"

    assert_not_nil assigns(:pages)
    assert_equal Page.count, assigns(:pages).size

    assert_not_nil assigns(:page)
    assert_equal TextFilter.find_by_name(this_blog.text_filter), assigns(:page).text_filter
  end

  def test_show
    get :show, :id => contents(:first_page).id
    assert_response :success
    assert_template "show"

    assert_not_nil assigns(:page)
    assert_equal contents(:first_page), assigns(:page)
  end

  def test_new
    get :new
    assert_response :success
    assert_template "new"
    assert_not_nil assigns(:page)

    assert_equal users(:tobi), assigns(:page).user
    assert_equal TextFilter.find_by_name(this_blog.text_filter), assigns(:page).text_filter

    post :new, :page => { :name => "new_page", :title => "New Page Title",
      :body => "Emphasis _mine_, arguments *strong*" }

    new_page = Page.find(:first, :order => "id DESC")

    assert_equal "new_page", new_page.name

    assert_response :redirect, :action => "show", :id => new_page.id

    # XXX: The flash is currently being made available improperly to tests (scoop)
    #assert_equal "Page was successfully created.", flash[:notice]
  end

  def test_edit
    get :edit, :id => contents(:markdown_page).id
    assert_response :success
    assert_template "edit"
    assert_not_nil assigns(:page)

    assert_equal contents(:markdown_page), assigns(:page)

    post :edit, :id => contents(:markdown_page).id, :page => { :name => "markdown-page", :title => "Markdown Page",
        :body => "Adding a [link](http://www.typosphere.org/) here" }

    assert_response :redirect, :action => "show", :id => contents(:markdown_page).id

    # XXX: The flash is currently being made available improperly to tests (scoop)
    #assert_equal "Page was successfully updated.", flash[:notice]
  end

  def test_destroy
    post :destroy, :id => contents(:another_page).id
    assert_response :redirect, :action => "list"
    assert_raise(ActiveRecord::RecordNotFound) { Page.find(contents(:another_page).id) }
  end
end
