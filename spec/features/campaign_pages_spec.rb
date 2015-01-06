feature 'Campaigns' do
  let(:campaigns_page)          { CampaignsPage.new }
  let(:new_campaigns_page)      { NewCampaignsPage.new }
  let(:existing_campaigns_page) { ExistingCampaignsPage.new }
  let!(:fake_campaign)          { create(:campaign, title: 'Save money at the supermarket', active: true) }

  background do
    create(:blog)
    sign_in(:as_admin)
    campaigns_page.load
  end

  scenario 'as an admin, i am able to view campaigns' do
    when_i_view_the_campaigns_page
    i_can_see_all_campaigns
  end

  scenario 'an an admin, i am able to create a campaign' do
    when_i_view_the_new_campaigns_page
    and_i_create_a_new_campaign
    then_i_see_a_successful_confirmation('Campaign created successfully')
  end

  scenario 'an an admin, i am able to update a campaign' do
    when_i_view_an_existing_campaign
    and_i_update_the_campaign
    then_i_see_a_successful_confirmation('Campaign updated successfully')
  end

  scenario 'as an admin, i am able to delete a campaign' do
    when_i_view_the_campaigns_page
    save_and_open_page
    and_i_delete_a_campaign
    then_i_see_a_successful_confirmation('Campaign deleted successfully')
  end

  def when_i_view_the_campaigns_page
    expect(campaigns_page).to be_displayed
  end

  def i_can_see_all_campaigns
    expect(page).to have_selector('a', text: fake_campaign.title)
  end

  def when_i_view_the_new_campaigns_page
    new_campaigns_page.load
    expect(new_campaigns_page).to be_displayed
  end

  def and_i_create_a_new_campaign
    new_campaigns_page.campaign_title.set 'Save money at the supermarket'
    new_campaigns_page.description.set 'Going to university is all about having a good time, discovering yourself and making new friends, right?'
    new_campaigns_page.active.set(true)
    new_campaigns_page.primary_link_type.select 'Ma Says'
    new_campaigns_page.primary_link_title.set 'Smart shopping: simple tips and tricks to save you money'
    new_campaigns_page.primary_link_url.set 'http//www.example.com'
    new_campaigns_page.secondary_link_type.select 'Blog'
    new_campaigns_page.secondary_link_title.set 'Save money in your shopping basket every week and if this title was longer it'
    new_campaigns_page.secondary_link_url.set 'http//www.example.com'
    new_campaigns_page.submit.click
  end

  def then_i_see_a_successful_confirmation(message)
    expect(page).to have_content(message)
  end

  def when_i_view_an_existing_campaign
    existing_campaigns_page.load(id: fake_campaign.id)
    expect(existing_campaigns_page).to be_displayed
  end

  def and_i_update_the_campaign
    existing_campaigns_page.campaign_title.set 'University fees rising'
    existing_campaigns_page.submit.click
  end

  def and_i_delete_a_campaign
    campaigns_page.delete.click
  end

end
