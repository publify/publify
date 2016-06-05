require 'rails_helper'

describe Admin::ProfilesController, type: :controller do
  render_views
  let!(:blog) { create(:blog) }
  let(:alice) { create(:user, login: 'alice', profile: Profile::ADMIN) }

  before do
    sign_in alice
  end

  describe '#index' do
    it 'should render index' do
      get :index
      expect(response).to render_template('index')
    end
  end

  describe '#update' do
    it 'redirects to profile page' do
      post :update, id: alice.id, user: { email: 'foo@bar.com' }
      expect(response).to redirect_to('/admin/profiles')
    end

    it 'does not allow updating your own profile' do
      post :update, id: alice.id, user: { profile: Profile::PUBLISHER }
      expect(alice.reload.profile).to eq Profile::ADMIN
    end
  end
end
