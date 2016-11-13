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
      res_id = create(:resource, upload: file_upload('hello')).id

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

    context 'when uploading a text file' do
      let(:upload) { file_upload('haha') }

      it 'creates a new Resource' do
        expect { post :upload, upload: upload }.
          to change { Resource.count }.by(1)
      end

      it 'sets the content type to text/plain' do
        post :upload, upload: upload
        expect(Resource.last.mime).to eq 'text/plain'
      end

      it 'sets the flash to success' do
        post :upload, upload: upload
        aggregate_failures do
          expect(flash[:success]).not_to be_nil
          expect(flash[:warning]).to be_nil
        end
      end
    end

    context 'when uploading an image file' do
      let(:upload) { file_upload('haha.png', 'testfile.png') }

      it 'creates a new image Resource' do
        expect { post :upload, upload: upload }.
          to change { Resource.count }.by(1)
      end

      it 'sets the content type correctly' do
        post :upload, upload: upload
        expect(Resource.last.mime).to eq 'image/png'
      end

      it 'sets the flash to success' do
        post :upload, upload: upload
        aggregate_failures do
          expect(flash[:success]).not_to be_nil
          expect(flash[:warning]).to be_nil
        end
      end
    end

    context 'when attempting to upload a dangerous svg' do
      let(:upload) { file_upload('danger.svg', 'exploit.svg') }

      before do
        upload.content_type = 'image/svg'
      end

      it 'does not create a new image Resource' do
        expect { post :upload, upload: upload }.
          not_to change { Resource.count }
      end

      it 'does not attempt to process a the image' do
        post :upload, upload: upload
        result = assigns(:up)
        expect(result.errors[:upload].first).not_to match(/^Failed to manipulate with MiniMagick/)
      end

      it 'sets the flash to failure' do
        post :upload, upload: upload
        aggregate_failures do
          expect(flash[:success]).to be_nil
          expect(flash[:warning]).not_to be_nil
        end
      end
    end

    context 'when attempting to upload a fake png' do
      let(:upload) { file_upload('haha.png', 'testfile.txt') }

      before do
        upload.content_type = 'image/png'
      end

      it 'does not create a new fake image Resource' do
        expect { post :upload, upload: upload }.
          not_to change { Resource.count }
      end

      it 'does not attempt to process a new fake image Resource' do
        post :upload, upload: upload
        result = assigns(:up)
        expect(result.errors[:upload].first).not_to match(/^Failed to manipulate with MiniMagick/)
      end

      it 'sets the flash to failure' do
        post :upload, upload: upload
        aggregate_failures do
          expect(flash[:success]).to be_nil
          expect(flash[:warning]).not_to be_nil
        end
      end
    end

    context 'when uploading nothing' do
      it 'does not create a new Resource' do
        expect { post :upload }.
          not_to change { Resource.count }
      end

      it 'sets the flash to failure' do
        post :upload
        aggregate_failures do
          expect(flash[:success]).to be_nil
          expect(flash[:warning]).not_to be_nil
        end
      end
    end
  end
end
