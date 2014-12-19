feature 'Campaigns' do
  let(:campaigns_page)  { CampaignsPage.new }
  let!(:fake_campaign)  { create(:campaign, title: 'Save money at the supermarket', active: true, primary_link: create(:campaign_link), secondary_link: create(:campaign_link, link_type: 'blog')) }

  background do
    create(:blog)
    sign_in(:as_admin)
    campaigns_page.load
  end

  scenario 'when viewing all campaigns' do
    when_i_view_the_campaigns_page_as_an_admin
    i_can_see_all_campaigns
  end

  def when_i_view_the_campaigns_page_as_an_admin
    expect(campaigns_page).to be_displayed
  end

  def i_can_see_all_campaigns
    expect(page).to have_selector('a', text: fake_campaign.title)
  end

end
