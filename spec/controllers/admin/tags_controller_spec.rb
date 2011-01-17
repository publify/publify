require 'spec_helper'

describe Admin::TagsController do

  before do
    Factory(:blog)
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
    before do
      @tag = Factory(:tag)
      post :edit, 'id' => @tag.id, 'tag' => {:display_name => 'Foo Bar'}
    end

    it 'should redirect to index' do
      response.should redirect_to(:action => 'index')
    end

    it 'should update tag' do
      @tag.reload
      @tag.name.should == 'foo-bar'
      @tag.display_name.should == "Foo Bar"
    end

    it 'should create a redirect from the old to the new' do
      old_name = @tag.name
      @tag.reload
      new_name = @tag.name

      r = Redirect.find_by_from_path "/tag/#{old_name}"
      r.to_path.should == "/tag/#{new_name}"
    end
  end

end
