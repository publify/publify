describe Admin::CampaignsController, type: :controller do
  render_views

  let!(:blog) { create(:blog) }
  let!(:user) { create(:user, :as_admin) }
  let(:valid_campaign)   { FactoryGirl.attributes_for(:campaign) }
  let(:invalid_campaign) { FactoryGirl.attributes_for(:campaign, title: 'Save money at the supermarket and this is a very long title that cannot be saved') }

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
      it "creates a new campaign" do
        expect{
          post :create, campaign: valid_campaign
        }.to change(Campaign, :count).by(1)
      end

      it "redirects to the campaigns index" do
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

  describe "#update" do
    before(:each) do
      @campaign = create(:campaign)
    end

    context 'with valid attributes' do
      it "locates the requested @campaign" do
        put :update, id: @campaign, campaign: valid_campaign
        expect(assigns(:campaign)).to eq(@campaign)
      end

      it "changes @campaign's attributes" do
        put :update, id: @campaign,
          campaign: FactoryGirl.attributes_for(:campaign, title: 'New awesome campaign title')
        @campaign.reload
        expect(@campaign.title).to eq('New awesome campaign title')
      end

      it "redirects to the campaigns index" do
        put :update, id: @campaign, campaign: valid_campaign
        expect(response).to redirect_to admin_campaigns_path
      end
    end

    context 'with invalid attributes' do
      it "locates the requested @campaign" do
        put :update, id: @campaign, campaign: invalid_campaign
        expect(assigns(:campaign)).to eq(@campaign)
      end

      it "does not change @campaign's attributes" do
        put :update, id: @campaign,
          campaign: invalid_campaign
        @campaign.reload
        expect(@campaign.title).not_to eq(invalid_campaign[:title])
      end

      it "re-renders the edit method" do
        put :update, id: @campaign, campaign: invalid_campaign
        expect(response).to render_template :edit
      end
    end
  end


end
