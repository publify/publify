require 'spec_helper'

describe Admin::TextfiltersController do
  render_views

  describe 'macro help action' do
    it 'should render success' do
      Factory(:blog)
      request.session = { :user => users(:tobi).id }
      get 'macro_help', :id => 'code'
      response.should be_success
    end
  end
end
