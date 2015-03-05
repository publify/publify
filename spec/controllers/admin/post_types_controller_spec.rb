require 'rails_helper'

describe Admin::PostTypesController, type: :controller do
  render_views

  before do
    create(:blog)
    user = create(:user, :as_admin)
    request.session = { user: user.id }
  end

  describe 'GET #index' do
    it 'responds successfully with an HTTP 200 status code' do
      get :index
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it 'renders the index template' do
      get :index
      expect(response).to render_template('index')
    end
  end

  describe 'create a new post_type' do
    it 'should create a post and redirect to #index' do
      expect do
        post :create, post_type: { name: 'new post type' }
        expect(response).to redirect_to(action: 'index')
        expect(PostType.count).to eq(1)
        expect(PostType.first.name).to eq('new post type')
      end.to change(PostType, :count)
    end
  end

  describe 'GET #edit' do
    before(:each) do
      get :edit, id: FactoryGirl.create(:post_type).id
    end

    it 'renders the edit template with an HTTP 200 status code' do
      expect(response).to be_success
      expect(response).to have_http_status(200)
      expect(response).to render_template('edit')
    end
  end

  describe '#update an existing post_type' do
    it 'should update a post_type and redirect to #index' do
      @test_id = FactoryGirl.create(:post_type).id
      post :update, id: @test_id, post_type: { name: 'another name' }
      assert_response :redirect, action: 'index'
      expect(PostType.count).to eq(1)
      expect(PostType.first.name).to eq('another name')
    end
  end

  describe 'destroy a post_type' do
    it 'should destroy the post_type and redirect to #index' do
      @test_id = FactoryGirl.create(:post_type).id
      post :destroy, id: @test_id
      expect(response).to redirect_to(action: 'index')
      expect(PostType.count).to eq(0)
    end
  end
end
