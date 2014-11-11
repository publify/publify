require 'rails_helper'

feature 'Sharing buttons' do
  let(:original_url) { 'fake_url' }

  background do
    create(:blog)
    allow_any_instance_of(ActionDispatch::Request)
      .to receive(:original_url) { original_url }
  end

  scenario 'when user visit the styleguide' do
    visit styleguide_show_path

    contains_sharing_bar
  end

  scenario 'when user visit the styleguide article page' do
    visit styleguide_article_page_path

    contains_sharing_bar
  end

  def contains_sharing_bar
    expect(page).to have_css('.t-sharing')
    expect(page).to have_css('.t-facebook-button')
    expect(page).to have_css('.t-twitter-button')
    expect(page.find('a.t-pinterest-button')['href']).to include(original_url)
    expect(page.find('a.t-google-button')['href']).to include(original_url)
    expect(page).to have_css('.t-print-button')
    expect(page).to have_css('.t-email-button')
  end
end
