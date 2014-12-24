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

  describe "#create" do
    context 'with valid attributes' do
      let(:valid_campaign)   { { title: 'Save money at the supermarket', description: 'blah' } }
      let(:invalid_campaign) { { title: 'Save money at the supermarket and this is a very long title that cannot be saved', description: 'blah' } }

      it "creates a new campaign" do
        expect{
          post :create, campaign: valid_campaign
        }.to change(Campaign, :count).by(1)
      end

      it "redirects to the new campaign" do
        post :create, campaign: valid_campaign
        expect(response).to redirect_to admin_campaigns_path
      end

      context "with invalid attributes" do
        it "does not save the new campaign" do
          expect{
            post :create, campaign: invalid_campaign
          }.to_not change(Campaign,:count)
        end

        it "re-renders the new method" do
          post :create, campaign: invalid_campaign
          expect(response).to render_template :new
        end
      end
    end
  end
end
