require 'spec_helper'

describe Admin::DashboardController do
  render_views
  
  before do
    Factory(:blog)
    #TODO Delete after removing fixtures
    Profile.delete_all
    henri = Factory(:user, :login => 'henri', :profile => Factory(:profile_admin, :label => Profile::ADMIN))
    request.session = { :user => henri.id }
    get :index
  end
  
  describe 'test index' do
    it "should render the index template" do
      response.should render_template('index')
    end
  end
end
