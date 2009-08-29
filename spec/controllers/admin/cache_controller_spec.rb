require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::CacheController, "rough port of the old functional test" do

  before(:each) do
    request.session = { :user => users(:tobi).id }
  end

  describe 'sweep_html action' do

    it 'should redirect to setting index' do
      get 'sweep_html'
      response.should redirect_to(:controller => '/admin/settings')
    end

  end

end
