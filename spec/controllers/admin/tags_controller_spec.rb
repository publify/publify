require File.dirname(__FILE__) + '/../../../test/test_helper'
require File.dirname(__FILE__) + '/../../spec_helper'
require 'admin/tags_controller'

# Re-raise errors caught by the controller.
class Admin::TagsController; def rescue_action(e) raise e end; end


describe Admin::TagsController do
  before do
    request.session = { :user => users(:tobi).id }
  end

  describe 'index action' do
    before :each do
      get :index
    end

    it 'should be success' do
      response.should be_success
    end

    it 'should render template index' do
      response.should render_template('index')
    end

  end


  describe 'edit action' do
    before(:each) do
      @tag_id = contents(:article1).tags.first.id
      get :edit, :id => @tag_id
    end

    it 'should be success' do
      response.should be_success
    end

    it 'should render template edit' do
      response.should render_template('edit')
    end

    it 'should assigns value :tag' do
      assert_valid assigns(:tag)
    end

  end


  describe 'update action' do

    before :each do
      @tag = Tag.find_by_id(contents(:article1).tags.first.id)
      post :edit, 'id' => @tag.id, 'tag' => {:name => 'foobar', :display_name => 'Foo Bar'}
    end

    it 'should redirect to index' do
      response.should redirect_to(:action => 'index')
    end

    it 'should update tag' do
      @tag.reload
      @tag.name.should == 'foobar'
      @tag.display_name == "Foo Bar"
    end

  end
  
end
