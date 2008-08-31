require File.dirname(__FILE__) + '/../../../test/test_helper'
require File.dirname(__FILE__) + '/../../spec_helper'
require 'admin/tags_controller'

# Re-raise errors caught by the controller.
class Admin::TagsController; def rescue_action(e) raise e end; end

describe Admin::TagsController do
  before do
    request.session = { :user => users(:tobi).id }
  end

  def test_index
    get :index
    assert_template 'index'
    assert_template_has 'tags'
  end
  
  def test_edit
    get :edit, 'id' => contents(:article1).tags.first.id
    assert_template 'edit'
    assert_template_has 'tag'
    assert_valid assigns(:tag)
  end
  
  def test_update
    tag = Tag.find_by_id(contents(:article1).tags.first.id)
    post :edit, 'id' => tag.id, 'tag' => {:name => 'foobar', :display_name => 'Foo Bar'}
    assert_response :redirect, :action => 'index'
    tag = Tag.find_by_id(contents(:article1).tags.first.id)
    assert_equal "foobar", tag.name
    assert_equal "Foo Bar", tag.display_name
  end
  
end