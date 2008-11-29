require File.dirname(__FILE__) + '/../../../test/test_helper'
require File.dirname(__FILE__) + '/../../spec_helper'
require 'admin/textfilters_controller'

# Re-raise errors caught by the controller.
class Admin::TextfiltersController; def rescue_action(e) raise e end; end

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
