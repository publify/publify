require 'rails_helper'

describe Admin::ThemesController, type: :controller do
  render_views

  before do
    create(:blog)
    henri = create(:user, :as_admin)
    sign_in henri
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

  it 'returns success for the :preview action' do
    get :preview, theme: 'plain'
    assert_response :success
  end
end
