require 'spec_helper'

describe Admin::ProfilesController do

  describe "#index" do
    it 'should render index' do
      FactoryGirl.create(:blog)
      #TODO Remove this after remove FIXTURES...
      Profile.delete_all
      alice = FactoryGirl.create(:user, :login => 'alice', :profile => FactoryGirl.create(:profile_admin, :label => Profile::ADMIN))
      request.session = { :user => alice.id }
      get :index
      response.should render_template('index')
    end
  end

  # TODO: Make RESTful
  describe "successful POST to index" do
    it "redirects to profile page" do
      FactoryGirl.create(:blog)
      #TODO Remove this after remove FIXTURES...
      Profile.delete_all
      alice = FactoryGirl.create(:user, :login => 'alice', :profile => FactoryGirl.create(:profile_admin, :label => Profile::ADMIN))
      request.session = { :user => alice.id }
      post :index, :user => {:email => 'foo@bar.com'}
      response.should render_template('index')
    end
  end
end
