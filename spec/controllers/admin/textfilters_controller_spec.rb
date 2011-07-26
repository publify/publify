require 'spec_helper'

describe Admin::TextfiltersController do
  render_views

  describe 'macro help action' do
    it 'should render success' do
      Factory(:blog)
      #TODO Delete after removing fixtures
      Profile.delete_all
      henri = Factory(:user, :login => 'henri', :profile => Factory(:profile_admin, :label => Profile::ADMIN))
      request.session = { :user => henri.id }
      get 'macro_help', :id => 'code'
      response.should be_success
    end
  end
end
