require 'rails_helper'

describe Admin::ResourcesController, type: :controller do
  render_views

  before do
    FactoryGirl.create(:blog)
    # TODO: Delete after removing fixtures
    Profile.delete_all
    henri = FactoryGirl.create(:user, login: 'henri', profile: FactoryGirl.create(:profile_admin, label: Profile::ADMIN))
    @request.session = { user: henri.id }
  end

  describe 'test_index' do
    before(:each) do
      get :index
    end

    it 'should render index template' do
      assert_response :success
      assert_template 'index'
      expect(assigns(:resources)).not_to be_nil
    end
  end

  describe 'test_destroy_image with get' do
    before(:each) do
      @res_id = FactoryGirl.create(:resource).id
      get :destroy, id: @res_id
    end

    it 'should render template destroy' do
      assert_response :success
      assert_template 'destroy'
    end

    it 'should have a valid file' do
      expect(Resource.find(@res_id)).not_to be_nil
      expect(assigns(:record)).not_to be_nil
    end
  end

  it 'test_destroy_image with POST' do
    res_id = FactoryGirl.create(:resource).id

    post :destroy, id: res_id
    expect(response).to redirect_to(action: 'index')
  end

  it 'test_upload' do
    # unsure how to test upload constructs :'(
  end
end
