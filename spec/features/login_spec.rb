require 'rails_helper'

RSpec.feature 'Logging in', type: :feature do
  before do
    load Rails.root.join('db', 'seeds.rb')
    Blog.first.update_attributes blog_name: 'Awesome!', base_url: 'http://www.example.com/'
    create :user, :as_admin, login: 'admin', password: 'a-secret'
  end

  scenario 'Admin logs in' do
    visit '/admin'
    fill_in :user_login, with: 'admin'
    fill_in :user_password, with: 'a-secret'

    click_button I18n.t('devise.sessions.new.sign_in')

    expect(page).to have_text I18n.t('devise.sessions.signed_in')
  end
end
