require File.dirname(__FILE__) + '/../../../test/test_helper'
require File.dirname(__FILE__) + '/../../spec_helper'
require 'admin/textfilters_controller'

# Re-raise errors caught by the controller.
class Admin::TextfiltersController; def rescue_action(e) raise e end; end

describe Admin::TextfiltersController do
  before do
    request.session = { :user_id => users(:tobi).id }
  end

  def test_new_without_filters
    post :new, :textfilter => { :name => 'filterx',
      :description => 'Filter X', :markup => 'markdown' }
    assert_response :redirect, :action => 'show'
  end

  def test_edit_without_filters
    post :edit, :id => text_filters(:markdown_filter).id, :textfilter => { :name => 'filterx',
      :description => 'Filter X', :markup => 'markdown' }
    assert_response :redirect, :action => 'show'
  end
end
