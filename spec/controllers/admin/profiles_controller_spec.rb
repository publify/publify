require 'rails_helper'

describe Admin::ProfilesController, type: :controller do
  render_views
  let!(:blog) { create(:blog) }
  let(:alice) { create(:user, login: 'alice', profile: create(:profile_admin, label: Profile::ADMIN)) }

  before do
    sign_in alice
  end

  describe '#index' do
    it 'should render index' do
      get :index
      expect(response).to render_template('index')
    end
  end

  describe 'successful POST to update' do
    it 'redirects to profile page' do
      post :update, id: alice.id, user: { email: 'foo@bar.com' }
      expect(response).to redirect_to('/admin/profiles')
    end
  end
end
