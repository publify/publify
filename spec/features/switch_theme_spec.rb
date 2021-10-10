# frozen_string_literal: true

require "rails_helper"

RSpec.feature "Changing themes", type: :feature do
  let(:admin) { create :user, :as_admin }
  let(:blog) { Blog.first }

  before do
    load Rails.root.join("db/seeds.rb")
    Blog.first.update blog_name: "Awesome!", base_url: "http://www.example.com/"
  end

  scenario "switching themes by clicking links in the themes admin" do
    sign_in admin
    visit "/admin/themes"

    expect(page).to have_text "plain - Active theme"

    click_link_or_button "Use this theme"

    expect(page).to have_text "bootstrap-2 - Active theme"
  end
end
