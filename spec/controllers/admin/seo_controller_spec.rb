require 'spec_helper'

describe Admin::SettingsController do
  render_views

  before(:each) do
    Factory(:blog)
    request.session = { :user => users(:tobi).id }
  end

  describe "#index" do
    it 'should render index' do
      get :index
      response.should render_template('index')
    end
  end

end