require 'spec_helper'

describe Admin::TagsController do
  before do
    create :blog
    henri = create :user, login: 'henri', profile: create(:profile_admin)
    request.session = { :user => henri.id }
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
      tag_id = FactoryGirl.create(:tag).id
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

  describe 'destroy action with GET' do
    before(:each) do
      @tag_id = create(:tag).id
      get :destroy, :id => @tag_id
    end

    it 'should be success' do
      response.should be_success
    end

    context "with view" do
      render_views

      it 'should have an id in the form destination' do
        response.should have_selector("form[action='/admin/tags/destroy/#{@tag_id}'][method='post']")
      end
    end

    it 'should render template edit' do
      response.should render_template('destroy')
    end

    it 'should assigns value :tag' do
      assert assigns(:record).valid?
    end
  end

  describe 'destroy action with POST' do
    before do
      @tag = FactoryGirl.create(:tag)
      post :destroy, 'id' => @tag.id, 'tag' => {:display_name => 'Foo Bar'}
    end

    it 'should redirect to index' do
      response.should redirect_to(:action => 'index')
    end

    it 'should have one less tags' do
      Tag.count.should == 0
    end
  end

  describe 'update action' do
    before do
      @tag = FactoryGirl.create(:tag)
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
