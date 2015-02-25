require 'rails_helper'

describe Admin::TagsController, type: :controller do
  render_views

  let!(:blog) { create(:blog) }
  let!(:user) { create(:user, login: 'henri', profile: create(:profile_admin)) }

  before { request.session = { user: user.id } }

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

  describe 'create a new tag' do
    it 'should create a tag and redirect to #index' do
      expect do
        post :create, tag: { display_name: 'new_tag' }
        expect(response).to redirect_to(action: 'index')
        expect(Tag.count).to eq(1)
        expect(Tag.first.display_name).to eq('new_tag')
      end.to change(Tag, :count)
    end
  end

  describe 'GET #edit' do
    before(:each) do
      get :edit, id: FactoryGirl.create(:tag).id
    end

    it 'renders the edit template with an HTTP 200 status code' do
      expect(response).to be_success
      expect(response).to have_http_status(200)
      expect(response).to render_template('edit')
    end
  end

  describe '#update an existing tag' do
    it 'should update a tag and redirect to #index' do
      @test_id = FactoryGirl.create(:tag).id
      post :update, id: @test_id, tag: { display_name: 'another_name' }
      assert_response :redirect, action: 'index'
      expect(Tag.count).to eq(1)
      expect(Tag.find(@test_id).display_name).to eq('another_name')
    end
  end

  describe 'destroy a tag' do
    it 'should destroy the tag and redirect to #index' do
      @test_id = FactoryGirl.create(:tag).id
      post :destroy, id: @test_id
      expect(response).to redirect_to(action: 'index')
      expect(Tag.count).to eq(0)
    end
  end
end
