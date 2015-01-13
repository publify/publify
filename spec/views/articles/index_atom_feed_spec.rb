require 'rails_helper'

describe 'articles/index_atom_feed.atom.builder', type: :view do
  let!(:blog) { build_stubbed :blog }

  let(:rendered_entry) { Feedjira::Feed.parse(rendered).entries.first }

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
    before do
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
      expect(view).to render_template(partial: 'shared/_atom_item_article',
                                      count: 2)
    end
  end

  describe 'rendering a single article' do
    before do
      @article = stub_full_article
      @article.body = 'public info'
      @article.extended = 'and more'
      assign(:articles, [@article])
    end

    it 'has the correct id' do
      render
      expect(rendered_entry.entry_id).to eq("urn:uuid:#{@article.guid}")
    end

    describe 'on a blog that shows extended content in feeds' do
      before do
        Blog.default.hide_extended_on_rss = false
        render
      end

      it 'shows the body and extended content in the feed' do
        expect(rendered_entry.content).to match(/public info.*and more/m)
      end

      it 'does not have a summary element in addition to the content element' do
        expect(rendered_entry.summary).to be_nil
      end
    end

    describe 'on a blog that hides extended content in feeds' do
      before do
        Blog.default.hide_extended_on_rss = true
      end

      it 'shows only the body content in the feed if there is no excerpt' do
        render
        entry = rendered_entry
        expect(entry.content).to match(/public info/)
        expect(entry.content).not_to match(/public info.*and more/m)
      end

      it 'shows the excerpt instead of the body content in the feed, if there is an excerpt' do
        @article.excerpt = 'excerpt'
        render
        entry = rendered_entry
        expect(entry.content).to match(/excerpt/)
        expect(entry.content).not_to match(/public info/)
      end

      it 'does not have a summary element in addition to the content element' do
        render
        expect(rendered_entry.summary).to be_nil
      end
    end

    describe 'on a blog that has an RSS description set' do
      before do
        Blog.default.rss_description = true
        Blog.default.rss_description_text = 'rss description'
        render
      end

      it 'shows the body content in the feed' do
        expect(rendered_entry.content).to match(/public info/)
      end

      it 'shows the RSS description in the feed' do
        expect(rendered_entry.content).to match(/rss description/)
      end
    end
  end

  describe 'rendering a password protected article' do
    before do
      @article = stub_full_article
      @article.body = "shh .. it's a secret!"
      @article.extended = 'even more secret!'
      allow(@article).to receive(:password) { 'password' }
      assign(:articles, [@article])
    end

    describe 'on a blog that shows extended content in feeds' do
      before do
        Blog.default.hide_extended_on_rss = false
        render
      end

      it 'shows only a link to the article' do
        expect(rendered_entry.content).to eq(
          "<p>This article is password protected. Please <a href='#{@article.permalink_url}'>fill in your password</a> to read it</p>"
        )
      end

      it 'does not have a summary element in addition to the content element' do
        expect(rendered_entry.summary).to be_nil
      end

      it 'does not show any secret bits anywhere' do
        expect(rendered).not_to match(/secret/)
      end
    end

    describe 'on a blog that hides extended content in feeds' do
      before do
        Blog.default.hide_extended_on_rss = true
        render
      end

      it 'shows only a link to the article' do
        expect(rendered_entry.content).to eq(
          "<p>This article is password protected. Please <a href='#{@article.permalink_url}'>fill in your password</a> to read it</p>"
        )
      end

      it 'does not have a summary element in addition to the content element' do
        expect(rendered_entry.summary).to be_nil
      end

      it 'does not show any secret bits anywhere' do
        expect(rendered).not_to match(/secret/)
      end
    end
  end

  describe '#title' do
    before(:each) do
      assign(:articles, [article])
      render
    end

    context 'with a note' do
      let(:article) { create(:note) }
      it { expect(rendered_entry.title).to eq(article.body) }
    end

    context 'with an article' do
      let(:article) { create(:article) }
      it { expect(rendered_entry.title).to eq(article.title) }
    end
  end
end
