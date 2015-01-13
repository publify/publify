# coding: utf-8
require 'rails_helper'

describe 'articles/index_rss_feed.rss.builder', type: :view do
  let!(:blog) { build_stubbed :blog }

  let(:rendered_entry) { Feedjira::Feed.parse(rendered).entries.first }
  let(:xml_entry) { Nokogiri::XML.parse(rendered).css('item').first }

  describe 'rendering articles (with some funny characters)' do
    before do
      article1 = stub_full_article(1.minute.ago)
      article1.body = '&eacute;coute!'
      article2 = stub_full_article(2.minutes.ago)
      article2.body = 'is 4 < 2? no!'
      assign(:articles, [article1, article2])
      render
    end

    it 'creates a valid RSS feed with two items' do
      assert_rss20 rendered, 2
    end

    it 'renders the article RSS partial twice' do
      expect(view).to render_template(partial: 'shared/_rss_item_article', count: 2)
    end
  end

  describe 'rendering a single article' do
    before do
      @article = stub_full_article
      @article.body = 'public info'
      @article.extended = 'and more'
      assign(:articles, [@article])
    end

    it 'has the correct guid' do
      render
      expect(rendered_entry.entry_id).to eq "urn:uuid:#{@article.guid}"
    end

    it "has a link to the article's comment section" do
      render
      expect(xml_entry.css('comments').first.content).to eq(@article.permalink_url + '#comments')
    end

    describe 'with an author without email set' do
      before(:each) do
        @article.user.email = nil
        render
      end

      it 'does not have an author entry' do
        expect(rendered_entry.author).to be_nil
      end
    end

    describe 'with an author with email set' do
      before(:each) do
        @article.user.email = 'foo@bar.com'
      end

      describe 'on a blog that links to the author' do
        before(:each) do
          Blog.default.link_to_author = true
          render
        end

        it 'has an author entry' do
          expect(rendered_entry.author).not_to be_empty
        end

        it "has the author's email in the author entry" do
          expect(rendered_entry.author).to match(/foo@bar.com/)
        end
      end

      describe 'on a blog that does not link' do
        before(:each) do
          Blog.default.link_to_author = false
          render
        end

        it 'does not have an author entry' do
          expect(rendered_entry.author).to be_nil
        end
      end
    end

    describe 'on a blog that shows extended content in feeds' do
      before(:each) do
        Blog.default.hide_extended_on_rss = false
        render
      end

      it 'shows the body and extended content in the feed' do
        expect(rendered_entry.summary).to match(/public info.*and more/m)
      end
    end

    describe 'on a blog that hides extended content in feeds' do
      before(:each) do
        Blog.default.hide_extended_on_rss = true
      end

      it 'shows only the body content in the feed if there is no excerpt' do
        render
        expect(rendered_entry.summary).to match(/public info/)
        expect(rendered_entry.summary).not_to match(/public info.*and more/m)
      end

      it 'shows the excerpt instead of the body content in the feed, if there is an excerpt' do
        @article.excerpt = 'excerpt'
        render
        expect(rendered_entry.summary).to match(/excerpt/)
        expect(rendered_entry.summary).not_to match(/public info/)
      end
    end

    describe 'on a blog that has an RSS description set' do
      before(:each) do
        Blog.default.rss_description = true
        Blog.default.rss_description_text = 'rss description'
        render
      end

      it 'shows the body content in the feed' do
        expect(rendered_entry.summary).to match(/public info/)
      end

      it 'shows the RSS description in the feed' do
        expect(rendered_entry.summary).to match(/rss description/)
      end
    end
  end

  describe 'rendering a password protected article' do
    before(:each) do
      @article = stub_full_article
      @article.body = "shh .. it's a secret!"
      @article.extended = 'even more secret!'
      allow(@article).to receive(:password) { 'password' }
      assign(:articles, [@article])
    end

    describe 'on a blog that shows extended content in feeds' do
      before(:each) do
        Blog.default.hide_extended_on_rss = false
        render
      end

      it 'shows only a link to the article' do
        expect(rendered_entry.summary).to eq(
          "<p>This article is password protected. Please <a href='#{@article.permalink_url}'>fill in your password</a> to read it</p>"
        )
      end

      it 'does not show any secret bits anywhere' do
        expect(rendered).not_to match(/secret/)
      end
    end

    describe 'on a blog that hides extended content in feeds' do
      before(:each) do
        Blog.default.hide_extended_on_rss = true
        render
      end

      it 'shows only a link to the article' do
        expect(rendered_entry.summary).to eq(
          "<p>This article is password protected. Please <a href='#{@article.permalink_url}'>fill in your password</a> to read it</p>"
        )
      end

      it 'does not show any secret bits anywhere' do
        expect(rendered).not_to match(/secret/)
      end
    end
  end

  describe 'rendering an article with a UTF-8 permalink' do
    before(:each) do
      @article = stub_full_article
      @article.permalink = 'ルビー'
      assign(:articles, [@article])

      render
    end

    it 'creates a valid RSS feed with one item' do
      assert_rss20 rendered, 1
    end
  end

  describe '#title' do
    before(:each) do
      assign(:articles, [article])
      render
    end

    context 'with a note' do
      let(:article) { create(:note) }
      it 'is equal to the note body' do
        expect(rendered_entry.title).to eq(article.body)
      end
    end

    context 'with an article' do
      let(:article) { create(:article) }
      it 'is equal to the article title' do
        expect(rendered_entry.title).to eq(article.title)
      end
    end
  end
end
