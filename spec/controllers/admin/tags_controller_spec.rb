require 'spec_helper'

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
      tag_id = Factory(:tag).id
      get :edit, :id => tag_id
    end

    it 'should be success' do
      response.should be_success
    end

    it 'should render template edit' do
      response.should render_template('edit')
    end

    it 'should assigns value :tag' do
      assert assigns(:tag).valid?
    end

  end

  describe 'update action' do

    it 'should redirect to index' do
      tag = Factory(:tag)
      post :edit, 'id' => tag.id, 'tag' => {:name => 'z'}
      response.should redirect_to(:action => 'index')
    end

    it 'should update tag' do
      tag = Factory(:tag)
      post :edit, 'id' => tag.id,
        'tag' => {:name => 'foobar', :display_name => 'Foo Bar'}
      tag.reload
      tag.name.should == 'foobar'
      tag.display_name == "Foo Bar"
    end

  end

end
