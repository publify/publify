require 'rails_helper'

describe 'authors/show_atom_feed.atom.builder', type: :view do
  let!(:blog) { create(:blog) }

  describe 'with no items' do
    before(:each) do
      assign(:articles, [])
      render
    end

    it 'renders the atom header partial' do
      expect(view).to render_template(partial: 'shared/_atom_header')
    end
  end

  describe 'rendering articles (with some funny characters)' do
    before(:each) do
      article1 = stub_full_article(1.minute.ago)
      article1.body = '&eacute;coute!'
      article2 = stub_full_article(2.minutes.ago)
      article2.body = 'is 4 < 2? no!'
      assign(:articles, [article1, article2])
      render
    end

    it 'creates a valid atom feed with two items' do
      assert_atom10 rendered, 2
    end

    it 'renders the article atom partial twice' do
      expect(view).to render_template(partial: 'shared/_atom_item_article', count: 2)
    end
  end
end
