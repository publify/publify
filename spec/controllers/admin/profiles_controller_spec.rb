describe Admin::ProfilesController, type: :controller do
  let!(:blog) { create(:blog) }
  let(:alice) { create(:user, login: 'alice', profile: create(:profile_admin, label: Profile::ADMIN)) }

  describe '#index' do
    it 'should render index' do
      request.session = { user: alice.id }
      get :index
      expect(response).to render_template('index')
    end
  end

  # TODO: Make RESTful
  describe 'successful POST to index' do
    it 'redirects to profile page' do
      request.session = { user: alice.id }
      post :index, user: { email: 'foo@bar.com' }
      expect(response).to render_template('index')
    end
  end
end
