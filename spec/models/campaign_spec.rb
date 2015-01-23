describe Campaign, type: :model do

  let(:campaign) do
    Campaign.new(title: 'Save money at the supermarket',
                 description: 'Going to university is all about having a good time, discovering yourself and making new friends, right? Well, yes but hopefully you will learn a lot and get a good qualification as well.',
                 hero_image:  File.new(Rails.root + 'app/assets/images/campaigns-hero-placeholder.png'),
                 hero_image_alt_text: 'alt text',
                 active: true)
  end

  subject { campaign }

  it { is_expected.to respond_to(:title) }
  it { is_expected.to respond_to(:description) }
  it { is_expected.to respond_to(:active) }
  it { is_expected.to respond_to(:primary_link) }
  it { is_expected.to respond_to(:secondary_link) }
  it { is_expected.to respond_to(:hero_image) }
  it { is_expected.to respond_to(:hero_image_alt_text) }
  it { is_expected.to respond_to(:full_bleed) }

  it { is_expected.to be_valid }

  describe "validations" do
    context 'when title is not present' do
      before { campaign.title = "" }

      it { is_expected.not_to be_valid }
    end

    context 'when title is too long' do
      before { campaign.title = "a" * 36  }

      it { is_expected.not_to be_valid }
    end

    context 'when description is not present' do
      before { campaign.description = "" }

      it { is_expected.not_to be_valid }
    end

    context 'when description is too long' do
      before { campaign.description = "a" * 188  }

      it { is_expected.not_to be_valid }
    end

    context 'when hero image is not present' do
      before {
        campaign.remove_hero_image = true
        campaign.save!
      }

      it { is_expected.not_to be_valid }
    end

    context 'when hero image alt is not present' do
      before { campaign.hero_image_alt_text = ""  }

      it { is_expected.not_to be_valid }
    end

    context 'when another campaign is active' do
      before do
        campaign.save
        second_campaign = campaign.dup
        second_campaign.save
      end

      it 'is no longer active' do
       expect(campaign.reload.active?).to be_falsey
      end
    end
  end

end
