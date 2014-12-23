describe Admin::CampaignsController, type: :controller do
  render_views

  let!(:blog) { create(:blog) }
  let!(:user) { create(:user, :as_admin) }

  before(:each) { request.session = { user: user.id } }

  describe '#index' do
    before(:each) { get :index }

    it { expect(response).to be_success }
    it { expect(response).to render_template('index') }
  end

  describe '#new' do
    context 'using GET' do
      before(:each) { get :new }

      it { expect(response).to be_success }
      it { expect(response).to render_template('new') }
      it { expect(assigns(:campaign)).to_not be_nil }
    end


  end
end
