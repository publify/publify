# frozen_string_literal: true

require "rails_helper"

describe Admin::ResourcesController, type: :controller do
  render_views

  before do
    create(:blog)
    admin = create :user, :as_admin
    sign_in admin
  end

  describe "#index" do
    before do
      get :index
    end

    it "renders index template" do
      assert_response :success
      assert_template "index"
      expect(assigns(:resources)).not_to be_nil
    end
  end

  describe "#destroy" do
    let(:uploaded_file) { file_upload("testfile.txt", "text/plain") }

    it "redirects to the index" do
      res_id = create(:resource, upload: uploaded_file).id

      delete :destroy, params: { id: res_id }
      expect(response).to redirect_to(action: "index")
    end
  end

  # TODO: Should be create, mkay?
  describe "#upload" do
    before do
      ResourceUploader.enable_processing = true
    end

    after do
      ResourceUploader.enable_processing = false
    end

    context "when uploading a text file" do
      let(:upload) { file_upload("testfile.txt", "text/plain") }

      it "creates a new Resource" do
        expect { post :upload, params: { upload: upload } }.
          to change(Resource, :count).by(1)
      end

      it "sets the content type to text/plain" do
        post :upload, params: { upload: upload }
        expect(Resource.last.mime).to eq "text/plain"
      end

      it "sets the flash to success" do
        post :upload, params: { upload: upload }
        aggregate_failures do
          expect(flash[:success]).not_to be_nil
          expect(flash[:warning]).to be_nil
        end
      end
    end

    context "when uploading an image file" do
      let(:upload) { file_upload("testfile.png", "image/png") }

      it "creates a new Resource" do
        expect { post :upload, params: { upload: upload } }.
          to change(Resource, :count).by(1)
      end

      it "sets the content type correctly" do
        post :upload, params: { upload: upload }
        expect(Resource.last.mime).to eq "image/png"
      end

      it "sets the flash to success" do
        post :upload, params: { upload: upload }
        aggregate_failures do
          expect(flash[:success]).not_to be_nil
          expect(flash[:warning]).to be_nil
        end
      end
    end

    context "when uploading an image file with exif data" do
      let(:upload) { file_upload("testfile.jpg", "image/jpeg") }

      it "creates a new Resource" do
        expect { post :upload, params: { upload: upload } }.
          to change(Resource, :count).by(1)
      end

      it "strips EXIF data" do
        post :upload, params: { upload: upload }
        resource = Resource.last
        img = MiniMagick::Image.open resource.upload.file.file
        expect(img.exif).to be_empty
      end

      it "sets the content type correctly" do
        post :upload, params: { upload: upload }
        expect(Resource.last.mime).to eq "image/jpeg"
      end

      it "sets the flash to success" do
        post :upload, params: { upload: upload }
        aggregate_failures do
          expect(flash[:success]).not_to be_nil
          expect(flash[:warning]).to be_nil
        end
      end
    end

    context "when attempting to upload a dangerous svg" do
      let(:upload) { file_upload("exploit.svg", "image/svg") }

      it "does not create a new image Resource" do
        expect { post :upload, params: { upload: upload } }.
          not_to change(Resource, :count)
      end

      it "does not attempt to process the image" do
        post :upload, params: { upload: upload }
        result = assigns(:up)
        expect(result.errors[:upload]).
          to match_array ["has MIME type mismatch", "can't be blank"]
      end

      it "sets the flash to failure" do
        post :upload, params: { upload: upload }
        aggregate_failures do
          expect(flash[:success]).to be_nil
          expect(flash[:warning]).not_to be_nil
        end
      end
    end

    context "when attempting to upload a fake png with a txt extension" do
      let(:upload) { file_upload("testfile.txt", "image/png") }

      it "does not create a new fake image Resource" do
        expect { post :upload, params: { upload: upload } }.
          not_to change(Resource, :count)
      end

      it "does not attempt to process a new fake image Resource" do
        post :upload, params: { upload: upload }
        result = assigns(:up)
        expect(result.errors[:upload]).
          to match_array ["has MIME type mismatch", "can't be blank"]
      end

      it "sets the flash to failure" do
        post :upload, params: { upload: upload }
        aggregate_failures do
          expect(flash[:success]).to be_nil
          expect(flash[:warning]).not_to be_nil
        end
      end
    end

    context "when attempting to upload a fake png with a png extension" do
      let(:upload) { file_upload("fakepng.png", "image/png") }

      it "does not create a new fake image Resource" do
        expect { post :upload, params: { upload: upload } }.
          not_to change(Resource, :count)
      end

      it "does not attempt to process a new fake image Resource" do
        post :upload, params: { upload: upload }
        result = assigns(:up)
        expect(result.errors[:upload]).
          to match_array ["has MIME type mismatch", "can't be blank"]
      end

      it "sets the flash to failure" do
        post :upload, params: { upload: upload }
        aggregate_failures do
          expect(flash[:success]).to be_nil
          expect(flash[:warning]).not_to be_nil
        end
      end
    end

    context "when attempting to upload an html file" do
      let(:upload) { file_upload("just_some.html", "text/html") }

      it "does not create a new Resource" do
        expect { post :upload, params: { upload: upload } }.
          not_to change(Resource, :count)
      end

      it "warns the user they can't upload this type of file" do
        post :upload, params: { upload: upload }
        result = assigns(:up)
        expect(result.errors[:upload]).
          to match_array [
            %r{You are not allowed to upload text/html files},
            "can't be blank",
          ]
      end

      it "sets the flash to failure" do
        post :upload, params: { upload: upload }
        aggregate_failures do
          expect(flash[:success]).to be_nil
          expect(flash[:warning]).not_to be_nil
        end
      end
    end

    context "when attempting to upload an html file as text/plain" do
      let(:upload) { file_upload("just_some.html", "text/plain") }

      it "does not create a new Resource" do
        expect { post :upload, params: { upload: upload } }.
          not_to change(Resource, :count)
      end

      it "warns the user they can't upload this type of file" do
        post :upload, params: { upload: upload }
        result = assigns(:up)
        expect(result.errors[:upload]).
          to match_array ["has MIME type mismatch", "can't be blank"]
      end

      it "sets the flash to failure" do
        post :upload, params: { upload: upload }
        aggregate_failures do
          expect(flash[:success]).to be_nil
          expect(flash[:warning]).not_to be_nil
        end
      end
    end

    context "when uploading nothing" do
      it "does not create a new Resource" do
        expect { post :upload }.
          not_to change(Resource, :count)
      end

      it "sets the flash to failure" do
        post :upload
        aggregate_failures do
          expect(flash[:success]).to be_nil
          expect(flash[:warning]).not_to be_nil
        end
      end
    end
  end
end
