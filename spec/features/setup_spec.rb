require 'rails_helper'

RSpec.feature 'Blog setup', type: :feature do
  before do
    load Rails.root.join('db', 'seeds.rb')
  end

  scenario 'User accesses blog for the first time' do
    visit '/'

    expect(page).to have_text I18n.t('setup.index.welcome_to_your_blog_setup')
    fill_in :setting_blog_name, with: 'Awesome blog'
    fill_in :setting_email, with: 'foo@bar.com'
    click_button I18n.t('generic.save')

    expect(page).to have_text I18n.t('accounts.confirm.success')

    expect(User.first.email).to eq 'foo@bar.com'
  end
end
