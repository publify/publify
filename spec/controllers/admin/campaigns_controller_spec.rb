describe Admin::CampaignsController, type: :controller do
  render_views

  let!(:blog) { create(:blog) }
  let!(:user) { create(:user, :as_admin) }

  before(:each) { request.session = { user: user.id } }

  describe '#index' do
    before(:each) { get :index }

    specify { expect(response).to be_success }
    specify { expect(response).to render_template('index') }
  end
end
