require 'rails_helper'

describe Admin::RedirectsController, :type => :controller do
  render_views

  before do
    FactoryGirl.create(:blog)
    #TODO Delete after removing fixtures
    Profile.delete_all
    henri = FactoryGirl.create(:user, :login => 'henri', :profile => FactoryGirl.create(:profile_admin, :label => Profile::ADMIN))
    request.session = { :user => henri.id }
  end

  describe "#index" do
    before(:each) do
      get :index
    end

    it 'should display index with redirects' do
      assert_response :redirect, :action => 'new'
    end
  end

  it "test_create" do
    expect do
      post :edit, 'redirect' => { :from_path => "some/place", 
        :to_path => "somewhere/else" }
      assert_response :redirect, :action => 'index'
    end.to change(Redirect, :count)
  end
  
  it "test_create with empty from path" do
    expect do
      post :edit, 'redirect' => { :from_path => "", 
        :to_path => "somewhere/else/else" }
      assert_response :redirect, :action => 'index'
    end.to change(Redirect, :count)
  end
  
  describe "#edit" do
    before(:each) do
      get :edit, :id => FactoryGirl.create(:redirect).id
    end

    it 'should render new template with valid redirect' do
      assert_template 'new'
      expect(assigns(:redirect)).not_to be_nil
      assert assigns(:redirect).valid?
    end
  end

  it "test_update" do
    post :edit, :id => FactoryGirl.create(:redirect).id
    assert_response :redirect, :action => 'index'
  end

  describe "test_destroy" do
    before(:each) do
      @test_id = FactoryGirl.create(:redirect).id
      expect(Redirect.find(@test_id)).not_to be_nil
    end

    describe 'with GET' do
      before(:each) do
        get :destroy, :id => @test_id
      end

      it 'should render destroy template' do
        assert_response :success
        assert_template 'destroy'
      end
    end

    describe 'with POST' do
      before(:each) do
        post :destroy, :id => @test_id
      end

      it 'should redirect to index' do
        assert_response :redirect, :action => 'index'
      end

      it 'should have no more redirects' do
        expect { Redirect.find(@test_id) }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end
end
