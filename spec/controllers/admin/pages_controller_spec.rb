# coding: utf-8
require 'spec_helper'

describe Admin::PagesController do
  render_views
  
  before do
    @blog = Factory(:blog)
    #TODO Delete after removing fixtures
    Profile.delete_all
    @henri = Factory(:user, :login => 'henri', :profile => Factory(:profile_admin, :label => Profile::ADMIN))
    request.session = { :user => @henri.id }
  end

  describe '#index' do
    it 'should response success' do
      get :index
      response.should be_success
      assert_template 'index'
      assert_not_nil assigns(:pages)
    end

    it 'should response success with :page args' do
      get :index, :page => 1
      response.should be_success
      assert_template 'index'
      assert_not_nil assigns(:pages)
    end

  end

  describe "new" do
    
    context "without page params" do
      before(:each) do
        get :new
      end

      it "should render template new and has a page object" do
        assert_response :success
        assert_template "new"
        assert_not_nil assigns(:page)
      end

      it "should assign to current user" do
        assert_equal @henri, assigns(:page).user
      end

      it "should have a text filter" do
        assert_equal TextFilter.find_by_name(@blog.text_filter), assigns(:page).text_filter
      end
    end

  end

  it "test_create" do
    post :new, :page => { :name => "new_page", :title => "New Page Title",
      :body => "Emphasis _mine_, arguments *strong*" }

    new_page = Page.find(:first, :order => "id DESC")

    assert_equal "new_page", new_page.name

    assert_response :redirect, :action => "show", :id => new_page.id

    # XXX: The flash is currently being made available improperly to tests (scoop)
    assert_equal "Page was successfully created.", flash[:notice]
  end

  describe "test_edit" do
    before(:each) do
      @page = Factory(:page)
      get :edit, :id => @page.id
    end

    it 'should render edit template' do
      assert_response :success
      assert_template "edit"
      assert_not_nil assigns(:page)
      assert_equal @page, assigns(:page)
    end

  end

  it 'test_update' do
    page = Factory(:page)
    post :edit, :id => page.id, :page => { :name => "markdown-page", :title => "Markdown Page",
      :body => "Adding a [link](http://www.typosphere.org/) here" }

    assert_response :redirect, :action => "show", :id => page.id

    # XXX: The flash is currently being made available improperly to tests (scoop)
    #assert_equal "Page was successfully updated.", flash[:notice]
  end

  it "test_destroy" do
    page = Factory(:page)
    post :destroy, :id => page.id
    assert_response :redirect, :action => "list"
    assert_raise(ActiveRecord::RecordNotFound) { Page.find(page.id) }
  end

  def base_page(options={})
    { :title => "posted via tests!",
      :body => "A good body",
      :name => "posted-via-tests",
      :published => true }.merge(options)
  end

  it 'should create a published page with a redirect' do
    post(:new, 'page' => base_page)
    assigns(:page).redirects.count.should == 1
  end

  it 'should create an unpublished page without a redirect' do
    post(:new, 'page' => base_page({:published => false}))
    assigns(:page).redirects.count.should == 0
  end

  it 'should create a page published in the future without a redirect' do
    pending ":published_at parameter is currently ignored"
    post(:new, 'page' => base_page({:published_at => (Time.now + 1.hour).to_s}))
    assigns(:page).redirects.count.should == 0
  end

  describe 'insert_editor action' do
    it 'should render _simple_editor' do
      get(:insert_editor, :editor => 'simple')
      response.should render_template('_simple_editor')
    end

    it 'should render _visual_editor' do
      get(:insert_editor, :editor => 'visual')
      response.should render_template('_visual_editor')
    end

    it 'should render _visual_editor even if editor param is set to unknow editor' do
      get(:insert_editor, :editor => 'unknow')
      response.should render_template('_visual_editor')
    end
  end
end
