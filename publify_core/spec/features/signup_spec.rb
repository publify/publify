require 'rails_helper'

RSpec.feature 'Signing up', type: :feature do
  before do
    stub_request(:get, 'http://www.google.com/search?output=rss&q=link:www.example.com&tbm=blg').
      to_return(status: 200, body: '', headers: {})
    load Rails.root.join('db', 'seeds.rb')
    Blog.first.update_attributes(blog_name: 'Awesome!',
                                 base_url: 'http://www.example.com/',
                                 allow_signup: 1)
    create :user, :as_admin, login: 'admin', password: 'a-secret'
  end

  scenario 'User signs up for an account' do
    visit admin_dashboard_path
    click_link I18n.t('accounts.create_account')

    # Create account
    fill_in :user_login, with: 'hello'
    fill_in :user_email, with: 'hello@hello.com'
    fill_in :user_password, with: 'hush-hush'
    fill_in :user_password_confirmation, with: 'hush-hush'
    click_button I18n.t!('devise.registrations.new.sign_up')

    # Confirm creation success
    expect(page).to have_text I18n.t!('devise.registrations.signed_up')

    # Sign out
    visit admin_dashboard_path
    find("a[href=\"#{destroy_user_session_path}\"]").click

    # Confirm ability to sign in
    visit admin_dashboard_path
    fill_in :user_login, with: 'hello'
    fill_in :user_password, with: 'hush-hush'
    find('input[type=submit]').click
    expect(page).to have_text I18n.t!('devise.sessions.signed_in')

    # Confirm proper setting fo user properties
    expect(User.last.email).to eq 'hello@hello.com'
  end
end
