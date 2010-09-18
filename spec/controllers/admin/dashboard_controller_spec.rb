require 'spec_helper'

describe Admin::DashboardController do
  before do
    request.session = { :user => users(:tobi).id }
  end

  it "test_index" do
    get :index
    response.should render_template('index')
  end

end
