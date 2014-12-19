describe CampaignLink, type: :model do

  let(:campaign) { create(:campaign) }
  let(:campaign_link) do
    CampaignLink.new(title: 'Save money in your shopping basket every week and if this title was longer it',
                     url: 'http://wwww.example.com',
                     link_type: 'ma_says',
                     campaign_id: campaign.id)
  end

  subject { campaign_link }

  it { is_expected.to respond_to(:title) }
  it { is_expected.to respond_to(:url) }
  it { is_expected.to respond_to(:link_type) }
  it { is_expected.to respond_to(:campaign_id) }

  it { is_expected.to be_valid }

  describe 'validations' do
    context 'when title is too long' do
      before { campaign_link.title = "a" * 78 }

      it { is_expected.not_to be_valid }
    end

    context 'when campaign id is not present' do
      before { campaign_link.campaign_id = nil }

      it { is_expected.not_to be_valid }
    end
  end


end
