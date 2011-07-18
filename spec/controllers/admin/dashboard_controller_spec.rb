require 'spec_helper'

describe Admin::DashboardController do
  render_views
  
  before do
    Factory(:blog)
    request.session = { :user => users(:tobi).id }
    get :index
  end
  
  describe 'test index' do
    it "should render the index template" do
      response.should render_template('index')
    end

    it 'should have Dashboard tab selected' do
      test_tabs "Dashboard"
    end
  end

end
