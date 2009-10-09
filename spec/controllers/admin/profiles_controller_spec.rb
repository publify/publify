require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::ProfilesController do

  describe "#index" do
    it 'should render index' do
      users(:tobi).profile.label.should == 'admin'
      request.session = { :user => users(:tobi).id }
      get :index
      response.should render_template('index')
    end
  end

  # TODO: Make RESTful
  describe "successful POST to index" do
    it "redirects to the admin page" do
      request.session = { :user => users(:tobi).id }
      post :index, :user => {:email => 'foo@bar.com'}
      response.should redirect_to(admin_url)
    end
  end
end
