feature 'Display ckeditor' do

  background do
    create(:blog)
    sign_in(:as_admin)
  end

  scenario 'when user writes an article', js: true do
    click_link('write a post')

    expect(page).to have_css('#cke_article_body_and_extended')
  end

  scenario 'when user writes a page', js: true do
    click_link('write a page')

    expect(page).to have_css('#cke_page_body')
  end
end
