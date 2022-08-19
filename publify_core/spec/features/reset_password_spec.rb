# frozen_string_literal: true

require "rails_helper"

RSpec.feature "Logging in", type: :feature do
  before do
    load Rails.root.join("db/seeds.rb")
    Blog.first.update blog_name: "Awesome!", base_url: "http://www.example.com/"
    create :user, :as_admin, login: "admin", password: "Fo_rgEt-1m5e2"
  end

  scenario "Admin resets password" do
    visit "/admin"
    click_link I18n.t("accounts.lost_my_password")

    fill_in :user_email, with: User.last.email
    click_button I18n.t("devise.passwords.new.send_me_reset_password_instructions")

    mail = ActionMailer::Base.deliveries.last
    html = Nokogiri::HTML.parse mail.body.raw_source
    link = html.at_css "a"
    url = link.attribute("href").value

    visit url

    fill_in :user_password, with: "a5-SeCre1T4"
    fill_in :user_password_confirmation, with: "a5-SeCre1T4"

    click_button I18n.t("devise.passwords.edit.change_my_password")
    expect(page).to have_text I18n.t("devise.passwords.updated")
  end
end
