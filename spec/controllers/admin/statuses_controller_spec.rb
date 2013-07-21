require 'spec_helper'

describe Admin::StatusesController do
  render_views

  describe "For index action" do
    before :each do
      create(:blog)
      #TODO Delete after removing fixtures
      Profile.delete_all
      henri = create(:user, :login => 'henri', :profile => create(:profile_admin, :label => Profile::ADMIN))
      request.session = { :user => henri.id }
    end
    
    it 'should render template index' do
      get 'index'
      response.should render_template('index')
    end
  
  end
  
  describe "For a new status" do
    before :each do
      create(:blog)
      #TODO Delete after removing fixtures
      Profile.delete_all
      henri = create(:user, :login => 'henri', :profile => create(:profile_admin, :label => Profile::ADMIN))
      request.session = { :user => henri.id }
    end
    
    it 'should render template new' do
      get 'new'
      response.should render_template('new')
    end
  end
  
  describe "Editing an existing status" do
    before :each do
      create(:blog)
      #TODO Delete after removing fixtures
      Profile.delete_all
      henri = create(:user, :login => 'henri', :profile => create(:profile_admin, :label => Profile::ADMIN))
      request.session = { :user => henri.id }
      @status = FactoryGirl.create(:status)
    end
    
    it 'should render template edit' do
      get 'edit', :id => @status.id
      response.should render_template('edit')
    end
  end
  
  describe "Creating a new status" do
    before :each do
      create(:blog)
      #TODO Delete after removing fixtures
      Profile.delete_all
      Status.delete_all
      henri = create(:user, :login => 'henri', :profile => create(:profile_admin, :label => Profile::ADMIN))
      request.session = { :user => henri.id }
      @status = FactoryGirl.create(:status)
    end
    
    it 'creates a status' do
      post :create, :status => { :body => "Emphasis _mine_, arguments *strong*" }
      
      Status.count.should == 2
      status = Status.find(:first, :order => "id DESC")
      status.body.should == "Emphasis _mine_, arguments *strong*"

      response.should redirect_to(:controller => 'statuses', :action => 'index')
      flash[:notice].should ==  "Status was successfully created."
    end

    it 'creates a status with a chosen permalink' do
      post :create, :status => { :body => "Emphasis _mine_, arguments *strong*", :permalink => 'my-cool-permalink' }
      
      Status.count.should == 2
      status = Status.find(:first, :order => "id DESC")
      status.body.should == "Emphasis _mine_, arguments *strong*"
      status.permalink.should == "my-cool-permalink"

      response.should redirect_to(:controller => 'statuses', :action => 'index')
      flash[:notice].should ==  "Status was successfully created."
    end

    
  end
    
  describe "Destorying a status" do
    before :each do
      create(:blog)
      #TODO Delete after removing fixtures
      Profile.delete_all
      henri = create(:user, :login => 'henri', :profile => create(:profile_admin, :label => Profile::ADMIN))
      request.session = { :user => henri.id }
      Status.delete_all
      @status = FactoryGirl.create(:status, :user_id => henri.id)
    end
    
    it 'should render template destroy' do
      get 'destroy', :id => @status.id
      response.should render_template('destroy')
      Status.count.should == 1
    end
    
    it 'should destroy the last existing status and return zero' do
      post 'destroy', :id => @status.id
      response.should redirect_to(:controller => 'admin/statuses', :action => 'index')
      Status.count.should == 0
    end
    
  end

end