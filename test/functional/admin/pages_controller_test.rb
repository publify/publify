require File.dirname(__FILE__) + '/../../test_helper'
require 'admin/pages_controller'

# Re-raise errors caught by the controller.
class Admin::PagesController; def rescue_action(e) raise e end; end

class Admin::PagesControllerTest < Test::Unit::TestCase
  fixtures :pages, :users, :text_filters, :settings

  def setup
    @controller = Admin::PagesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.session = { :user => @tobi }
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
    assert_equal TextFilter.find_by_name(config[:text_filter]), assigns(:page).text_filter
  end

  def test_show
    get :show, :id => @first_page.id
    assert_response :success
    assert_template "show"
    
    assert_not_nil assigns(:page)
    assert_equal @first_page, assigns(:page)
  end

  def test_new
    get :new
    assert_response :success
    assert_template "new"
    assert_not_nil assigns(:page)
    
    assert_equal @tobi, assigns(:page).user
    assert_equal TextFilter.find_by_name(config[:text_filter]), assigns(:page).text_filter

    post :new, :page => { :name => "new_page", :title => "New Page Title",
      :body => "Emphasis _mine_, arguments *strong*" }

    new_page = Page.find(:first, :order => "id DESC")

    assert_equal "new_page", new_page.name
    assert_nil new_page.body_html

    assert_redirected_to :action => "show", :id => new_page.id
    assert_equal "Page was successfully created.", flash[:notice]
  end
  
  def test_edit
    get :edit, :id => @markdown_page.id
    assert_response :success
    assert_template "edit"
    assert_not_nil assigns(:page)
    
    assert_equal @markdown_page, assigns(:page)

    post :edit, :id => @markdown_page.id, :page => { :name => "markdown-page", :title => "Markdown Page",
        :body => "Adding a [link](http://typo.leetsoft.com/) here" }

    assert_equal "", @markdown_page.reload.body_html.to_s

    assert_redirected_to :action => "show", :id => @markdown_page.id
    assert_equal "Page was successfully updated.", flash[:notice]
  end

  def test_destroy
    post :destroy, :id => @another_page.id
    assert_redirected_to :action => "list"
    assert_raise(ActiveRecord::RecordNotFound) { Page.find(@another_page.id) }
  end

  def test_preview
    get :preview, :page => { :name => "preview-page", :title => "Preview Page",
      :text_filter_id => @markdown_filter.id, :body => "testing the *preview*" }
    assert_response :success
    assert_not_nil assigns(:page)
    assert_template "preview"

#    assert_equal "<p>testing the <em>preview</em></p>", assigns(:page).body_html

    assert_tag :tag => "h3",
      :content => "Preview Page",
      :sibling => { :tag => "p",
        :children => { :count => 1,
          :only => { :tag => "p",
            :children => { :count => 1,
              :only => { :tag => "em",
                :content => "preview" } } } } }
  end
end
