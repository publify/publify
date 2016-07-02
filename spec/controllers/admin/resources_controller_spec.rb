require 'rails_helper'

describe Admin::ResourcesController, type: :controller do
  render_views

  before do
    create(:blog)
    admin = create :user, :as_admin
    sign_in admin
  end

  describe '#index' do
    before(:each) do
      get :index
    end

    it 'should render index template' do
      assert_response :success
      assert_template 'index'
      expect(assigns(:resources)).not_to be_nil
    end
  end

  describe '#destroy' do
    it 'redirects to the index' do
      res_id = FactoryGirl.create(:resource).id

      delete :destroy, id: res_id
      expect(response).to redirect_to(action: 'index')
    end
  end

  # TODO: Should be create, mkay?
  describe '#upload' do
    before do
      ResourceUploader.enable_processing = true
    end

    after do
      ResourceUploader.enable_processing = false
    end

    it 'creates a new Resource' do
      expect { post :upload, upload: { filename: file_upload('haha') } }.
        to change { Resource.count }.by(1)
    end

    it 'creates a new image Resource' do
      upload = file_upload('haha.png', 'testfile.png')
      expect { post :upload, upload: { filename: upload } }.
        to change { Resource.count }.by(1)
    end
  end
end
