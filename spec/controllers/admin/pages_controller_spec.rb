# coding: utf-8
require 'spec_helper'

describe Admin::PagesController do
  render_views

  def base_page(options={})
    { :title => "posted via tests!",
      :body => "A good body",
      :name => "posted-via-tests",
      :published => true }.merge(options)
  end

  let!(:blog) { create(:blog) }

    let(:user) { create(:user, profile: create(:profile_admin)) }
  before(:each) { request.session = { user: user.id } }

  describe :index do
    context "without params" do
      before(:each) { get :index }
      it { expect(response).to be_success }
      it { expect(response).to render_template('index') }
      it { expect(assigns(:pages)).to_not be_nil }
    end

    context "with page 1" do
      before(:each) { get :index, page: 1 }
      it { expect(response).to be_success }
      it { expect(response).to render_template('index') }
      it { expect(assigns(:pages)).to_not be_nil }
    end
  end

  describe :new do
    context "using get" do
      context "without page params" do
        it "should render template new and has a page object" do
          get :new
          expect(response).to be_success
          expect(response).to render_template("new")
          expect(assigns(:page)).to_not be_nil
        end

        it "should assign to current user" do
          get :new
          expect(assigns(:page).user).to eq(user)
        end

        it "should have a text filter" do
          get :new
          assigns(:page).text_filter.name.should eq 'textile'
        end
      end
    end

    context "using post" do
      it "test_create" do
        post :new, :page => { :name => "new_page", :title => "New Page Title",
                              :body => "Emphasis _mine_, arguments *strong*" }

        new_page = Page.find(:first, :order => "id DESC")

        assert_equal "new_page", new_page.name

        assert_response :redirect, :action => "show", :id => new_page.id

        # XXX: The flash is currently being made available improperly to tests (scoop)
        assert_equal "Page was successfully created.", flash[:notice]
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

    end
  end

  describe :edit do
    context "using get" do
      before(:each) do
        @page = FactoryGirl.create(:page)
        get :edit, :id => @page.id
      end

      it 'should render edit template' do
        assert_response :success
        assert_template "edit"
        assert_not_nil assigns(:page)
        assert_equal @page, assigns(:page)
      end

    end

    context "using post" do
      it 'test_update' do
        page = FactoryGirl.create(:page)
        post :edit, :id => page.id, :page => { :name => "markdown-page", :title => "Markdown Page",
                                               :body => "Adding a [link](http://www.publify.co/) here" }

        assert_response :redirect, :action => "show", :id => page.id
        # XXX: The flash is currently being made available improperly to tests (scoop)
        #assert_equal "Page was successfully updated.", flash[:notice]
      end
    end
  end

  describe :destroy do
    it "test_destroy" do
      page = FactoryGirl.create(:page)
      post :destroy, :id => page.id
      assert_response :redirect, :action => "list"
      assert_raise(ActiveRecord::RecordNotFound) { Page.find(page.id) }
    end
  end
end

