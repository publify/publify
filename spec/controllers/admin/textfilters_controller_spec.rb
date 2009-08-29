require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::TextfiltersController do

  integrate_views

  before do
    request.session = { :user => users(:tobi).id }
  end

  describe 'macro help action' do

    it 'should render success' do
      get 'macro_help', :id => 'code'
      response.should be_success
    end

  end

end
