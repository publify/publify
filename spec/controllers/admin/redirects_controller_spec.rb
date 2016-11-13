require 'rails_helper'

describe Admin::RedirectsController, type: :controller do
  before do
    create(:blog)
    admin = create(:user, :as_admin)
    sign_in admin
  end

  describe '#index' do
    it 'responds successfully with an HTTP 200 status code' do
      get :index
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it 'renders the index template' do
      get :index
      expect(response).to render_template('index')
    end

    it 'assigns only redirects that are not linked to content' do
      create(:article)
      redirect = create(:redirect)
      get :index
      expect(assigns(:redirects)).to match_array [redirect]
    end

    context 'when rendering the view' do
      render_views

      it 'renders properly with no redirects present' do
        expect { get :index }.not_to raise_error
      end

      it 'renders properly with redirects present' do
        create :redirect
        expect { get :index }.not_to raise_error
      end
    end
  end

  describe '#create' do
    it 'should create a new redirect and redirect to #index' do
      expect do
        post :create, 'redirect' => { from_path: 'some/place',
                                      to_path: 'somewhere/else' }
        assert_response :redirect, action: 'index'
      end.to change(Redirect, :count)
    end

    it 'should create a redirect with an empty from path and redirect to #index' do
      expect do
        post :create, 'redirect' => { from_path: '',
                                      to_path: 'somewhere/different' }
        assert_response :redirect, action: 'index'
      end.to change(Redirect, :count)
    end
  end

  describe 'GET #edit' do
    before(:each) do
      get :edit, id: FactoryGirl.create(:redirect).id
    end

    it 'renders the edit template with an HTTP 200 status code' do
      expect(response).to be_success
      expect(response).to have_http_status(200)
      expect(response).to render_template('edit')
    end
  end

  describe '#update an existing redirect' do
    it 'should update and redirect to #index' do
      @test_id = FactoryGirl.create(:redirect).id
      post :update, id: @test_id, redirect: { from_path: 'somewhere/over', to_path: 'the/rainbow' }
      assert_response :redirect, action: 'index'
      expect(Redirect.count).to eq(1)
      expect(Redirect.first.from_path).to eq('somewhere/over')
      expect(Redirect.first.to_path).to eq('the/rainbow')
    end
  end

  describe '#destroy a redirect' do
    before(:each) do
      @test_id = FactoryGirl.create(:redirect).id
      expect(Redirect.find(@test_id)).not_to be_nil
    end

    it 'should redirect to index' do
      post :destroy, id: @test_id
      assert_response :redirect, action: 'index'
    end

    it 'should no longer exist' do
      post :destroy, id: @test_id
      expect { Redirect.find(@test_id) }.to raise_error ActiveRecord::RecordNotFound
    end
  end
end
