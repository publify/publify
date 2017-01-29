require 'rails_helper'

RSpec.feature 'Drafting articles', type: :feature do
  let(:admin) { create :user, :as_admin }

  before do
    load Rails.root.join('db', 'seeds.rb')
    Blog.first.update_attributes blog_name: 'Awesome!', base_url: 'http://www.example.com/'
  end

  scenario 'Updating a future article' do
    sign_in admin
    visit '/admin/content'

    click_link I18n.t('admin.content.index.new_article')
    fill_in :article_title, with: 'This is the title'
    fill_in :article_body_and_extended, with: 'This is the body'
    fill_in :article_published_at, with: 10.days.from_now
    within '.modal-footer' do
      click_button I18n.t('admin.content.form.publish')
    end

    find('a[href="/admin/content/1/edit"]').click
    fill_in :article_title, with: 'This is the draft updated title'
    click_button I18n.t('admin.content.form.save_as_draft')

    # TODO: Determine desired outcome after these steps.
  end
end
