require 'rails_helper'

describe Admin::ThemesController, type: :controller do
  render_views

  before do
    FactoryGirl.create(:blog)
    # TODO: Delete after removing fixtures
    Profile.delete_all
    henri = FactoryGirl.create(:user, login: 'henri', profile: FactoryGirl.create(:profile_admin, label: Profile::ADMIN))
    request.session = { user: henri.id }
  end

  describe 'test index' do
    before(:each) do
      get :index
    end

    it 'assigns @themes for the :index action' do
      assert_response :success
      expect(assigns(:themes)).not_to be_nil
    end
  end

  it 'redirects to :index after the :switchto action' do
    get :switchto, theme: 'typographic'
    assert_response :redirect, action: 'index'
  end

  it 'returns succes for the :preview action' do
    get :preview, theme: 'bootstrap-2'
    assert_response :success
  end
end
