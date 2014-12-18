feature 'Campaigns' do
  let(:campaigns_page) { CampaignsPage.new }

  background do
    create(:blog)
    sign_in(:as_admin)
    campaigns_page.load
  end

  scenario 'Accessing the campaigns page' do
    i_view_the_campaigns_page
  end

  def i_view_the_campaigns_page
    expect(campaigns_page).to be_displayed
  end

end
