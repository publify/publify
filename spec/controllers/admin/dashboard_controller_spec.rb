require 'spec_helper'

describe Admin::DashboardController do

  it "test_index" do
    Factory(:blog)
    request.session = { :user => users(:tobi).id }
    get :index
    response.should render_template('index')
  end

end
