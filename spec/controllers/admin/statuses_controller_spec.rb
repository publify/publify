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

    it 'should redirect to new' do
      get 'index'
      response.should redirect_to(:action => 'new')
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
      response.should render_template('new')
    end
  end

  describe :new do
    describe "Creating a new status" do
      let!(:blog) { create(:blog) }
      let(:henri) { create(:user, :login => 'henri', :profile => create(:profile_admin, :label => Profile::ADMIN)) }

      before(:each) { request.session = { :user => henri.id } }

      context "without permalink" do
        before(:each) { post :new, status: { body: "Emphasis _mine_, arguments *strong*" } }

        it {expect(response).to redirect_to(controller: 'statuses', action: 'new')}
        it {expect(Status.count).to eq(1) }
        it {expect(Status.first.body).to eq("Emphasis _mine_, arguments *strong*") }
        it {expect(flash[:notice]).to eq("Status was successfully created.") }
      end

      context "with permalink" do
        before(:each) { post :new, status: { body: "Emphasis _mine_, arguments *strong*", permalink: 'my-cool-permalink'} }

        it { expect(Status.last.permalink).to eq("my-cool-permalink") }
      end
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
