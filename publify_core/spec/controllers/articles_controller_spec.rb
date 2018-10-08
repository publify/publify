# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ArticlesController, 'base', type: :controller do
  describe '#tag' do
    let!(:blog) { create(:blog) }
    let!(:user) { create :user }

    it 'redirects to TagsContoller#index' do
      get :tag

      expect(response).to redirect_to(tags_path)
    end
  end

  describe '#index' do
    let!(:blog) { create(:blog) }
    let!(:user) { create :user }

    context 'without any parameters' do
      let!(:article) { create(:article) }
      let!(:note) { create(:note) }

      before do
        get :index
      end

      it { expect(response).to render_template(:index) }
      it { expect(assigns[:articles]).to_not be_empty }

      it 'has no meta keywords for a blog without keywords' do
        expect(assigns(:keywords)).to eq('')
      end

      context 'with the view rendered' do
        render_views

        it 'should have good link feed rss' do
          expect(response.body).to have_selector('head>link[href="http://test.host/articles.rss"]', visible: false)
        end

        it 'should have good link feed atom' do
          expect(response.body).to have_selector('head>link[href="http://test.host/articles.atom"]', visible: false)
        end

        it 'should have a canonical url' do
          expect(response.body).to have_selector("head>link[href='#{blog.base_url}/']", visible: false)
        end

        it 'should have good title' do
          expect(response.body).to have_selector('title', text: 'test blog | test subtitle', visible: false)
        end
      end
    end

    context 'when an article has an excerpt' do
      render_views
      let!(:article) { create :article, excerpt: 'foo', body: 'bar' }

      it 'renders a continue reading link' do
        get :index

        aggregate_failures do
          expect(response.body).not_to have_text 'bar'
          expect(response.body).to have_text 'foo'
          expect(response.body).
            to have_text I18n.t!('articles.article_excerpt.continue_reading')
        end
      end
    end

    context 'for a month' do
      before(:each) do
        create(:article, published_at: Time.utc(2004, 4, 23))
        get 'index', params: { year: 2004, month: 4 }
      end

      it 'should render template index' do
        expect(response).to render_template(:index)
      end

      it 'should contain some articles' do
        expect(assigns[:articles]).not_to be_nil
        expect(assigns[:articles]).not_to be_empty
      end

      context 'with the view rendered' do
        render_views
        it 'should have a canonical url' do
          expect(response.body).to have_selector("head>link[href='#{blog.base_url}/2004/4']", visible: false)
        end

        it 'should have a good title' do
          expect(response.body).to have_selector('title', text: 'Archives for test blog', visible: false)
        end
      end
    end

    context 'for feeds' do
      let!(:article1) { create(:article, created_at: 1.day.ago) }
      let!(:article2) { create(:article, published_at: '2004-04-01 12:00:00') }

      let(:trackback) { create(:trackback, article: article1, published_at: 1.day.ago) }

      specify '/articles.atom => an atom feed' do
        get 'index', params: { format: 'atom' }
        expect(response).to be_successful
        expect(response).to render_template('index_atom_feed', layout: false)
        expect(assigns(:articles)).to eq([article1, article2])
      end

      specify '/articles.rss => an RSS 2.0 feed' do
        get 'index', params: { format: 'rss' }
        expect(response).to be_successful
        expect(response).to render_template('index_rss_feed', layout: false)
        expect(assigns(:articles)).to eq([article1, article2])
      end

      specify 'atom feed for archive should be valid' do
        get 'index', params: { year: 2004, month: 4, format: 'atom' }
        expect(response).to render_template('index_atom_feed', layout: false)
        expect(assigns(:articles)).to eq([article2])
      end

      specify 'RSS feed for archive should be valid' do
        get 'index', params: { year: 2004, month: 4, format: 'rss' }
        expect(response).to render_template('index_rss_feed', layout: false)
        expect(assigns(:articles)).to eq([article2])
      end
    end

    context 'with an accept header' do
      before do
        create(:article)
      end

      it 'should ignore the HTTP Accept: header' do
        request.env['HTTP_ACCEPT'] = 'application/atom+xml'
        get 'index'
        expect(response).to render_template('index')
      end
    end

    context "with blog meta keywords to 'publify, is, amazing'" do
      let!(:blog) { create(:blog, meta_keywords: 'publify, is, amazing') }

      it 'index without option but with blog keywords should have meta keywords' do
        get 'index'
        expect(assigns(:keywords)).to eq('publify, is, amazing')
      end
    end

    context 'when blog settings is empty' do
      let!(:blog) { create(:blog, settings: {}) }

      it 'redirects to setup' do
        get 'index'
        expect(response).to redirect_to(controller: 'setup', action: 'index')
      end
    end

    context 'when there are no users' do
      before do
        User.destroy_all
      end

      it 'redirects to signup' do
        get 'index'
        expect(response).to redirect_to new_user_registration_path
      end
    end
  end

  describe '#search' do
    let!(:blog) { create(:blog) }
    let!(:user) { create :user }

    before(:each) do
      create(:article, body: "in markdown format\n\n * we\n * use\n [ok](http://blog.ok.com) to define a link", text_filter: create(:markdown))
      create(:article, body: 'xyz')
    end

    describe 'a valid search' do
      before(:each) { get :search, params: { q: 'a' } }

      it { expect(response).to render_template(:search) }
      it { expect(assigns[:articles]).to_not be_nil }

      context 'with the view rendered' do
        render_views
        it 'should have good feed rss link' do
          expect(response.body).to have_selector('head>link[href="http://test.host/search/a.rss"]', visible: false)
        end

        it 'should have good feed atom link' do
          expect(response.body).to have_selector('head>link[href="http://test.host/search/a.atom"]', visible: false)
        end

        it 'should have a canonical url' do
          expect(response.body).to have_selector("head>link[href='#{blog.base_url}/search/a']", visible: false)
        end

        it 'should have a good title' do
          expect(response.body).to have_selector('title', text: 'Results for a | test blog', visible: false)
        end

        it 'should have content markdown interpret and without html tag' do
          expect(response.body).to have_selector('div') do |div|
            expect(div).to match(%{in markdown format * we * use [ok](http://blog.ok.com) to define a link})
          end
        end
      end
    end

    it 'should render feed rss by search' do
      get 'search', params: { q: 'a', format: 'rss' }
      expect(response).to be_successful
      expect(response).to render_template('index_rss_feed', layout: false)
    end

    it 'should render feed atom by search' do
      get 'search', params: { q: 'a', format: 'atom' }
      expect(response).to be_successful
      expect(response).to render_template('index_atom_feed', layout: false)
    end

    it 'search with empty result' do
      get 'search', params: { q: 'abcdefghijklmnopqrstuvwxyz' }
      expect(response).to render_template('articles/error', layout: false)
    end
  end

  describe '#livesearch' do
    context 'with a query with several words' do
      before(:each) do
        create(:article, body: 'hello world and im herer')
        create(:article, title: 'hello', body: 'worldwide')
        create(:article)
        get :live_search, params: { q: 'hello world' }
      end

      it 'should be valid' do
        expect(assigns(:articles).size).to eq(2)
      end

      it 'should render without layout' do
        expect(response).to render_template(layout: nil)
      end

      it 'should render template live_search' do
        expect(response).to render_template('live_search')
      end

      context 'with the view rendered' do
        render_views
        it 'should not have h3 tag' do
          expect(response.body).to have_selector('h3')
        end
      end

      it 'should assign @search the search string' do
        expect(assigns[:search]).to be_equal(controller.params[:q])
      end
    end
  end

  describe '#archives' do
    let(:blog) { create :blog }

    context 'for an archive with several articles' do
      let!(:articles) { create_list :article, 3 }

      before do
        get 'archives'
      end

      it 'renders the correct template' do
        expect(response).to render_template(:archives)
      end

      it 'assigns the articles' do
        expect(assigns[:articles]).to match_array articles
      end

      context 'when rendering' do
        render_views

        it 'has the correct self-link and title' do
          expect(response.body).
            to have_selector("head>link[href='#{blog.base_url}/archives']", visible: false).
            and have_selector('title', text: 'Archives for test blog', visible: false)
        end

        it 'shows the current month only once' do
          expect(response.body).
            to have_css('h3', count: 1).
            and have_text I18n.l(articles.first.published_at, format: :letters_month_with_year)
        end
      end
    end

    context 'for an archive with an article with tags' do
      render_views

      it 'renders correctly' do
        create :article, keywords: 'foo, bar'
        get 'archives'

        expect(response.body).to have_text 'foo'
        expect(response.body).to have_text 'bar'
      end
    end
  end

  describe '#preview' do
    let!(:blog) { create(:blog) }

    context 'with non logged user' do
      before :each do
        get :preview, params: { id: create(:article).id }
      end

      it 'should redirect to login' do
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'with logged user' do
      let(:admin) { create(:user, :as_admin) }
      let(:article) { create(:article, user: admin) }

      before do
        sign_in admin
      end

      describe 'theme rendering' do
        render_views
        with_each_theme do |theme, view_path|
          it "should render template #{view_path}/articles/read" do
            blog.theme = theme
            blog.save!
            get :preview, params: { id: article.id }
            expect(response).to render_template('articles/read')
          end
        end
      end

      it 'should assigns article define with id' do
        get :preview, params: { id: article.id }
        expect(assigns[:article]).to eq(article)
      end

      it 'should assigns last article with id like parent_id' do
        draft = create(:article, parent_id: article.id)
        get :preview, params: { id: article.id }
        expect(assigns[:article]).to eq(draft)
      end

      context 'when the article has an excerpt' do
        render_views
        let(:article) { create :article, excerpt: 'foo', body: 'bar', user: admin }

        it 'does not render a continue reading link' do
          get :preview, params: { id: article.id }

          aggregate_failures do
            expect(response.body).to have_text 'bar'
            expect(response.body).not_to have_text 'foo'
            expect(response.body).
              not_to have_text I18n.t!('articles.article_excerpt.continue_reading')
          end
        end
      end
    end
  end

  describe '#redirect' do
    describe 'with explicit redirects' do
      describe 'with empty relative_url_root' do
        it 'should redirect from known URL' do
          create(:blog, base_url: 'http://test.host')
          create(:user)
          create(:redirect)
          get :redirect, params: { from: 'foo/bar' }
          expect(response).to redirect_to('http://test.host/someplace/else')
        end

        it 'should not redirect from unknown URL' do
          create(:blog, base_url: 'http://test.host')
          create(:user)
          create(:redirect)
          expect { get :redirect, params: { from: 'something/that/isnt/there' } }.
            to raise_error ActiveRecord::RecordNotFound
        end
      end

      # FIXME: Due to the changes in Rails 3 (no relative_url_root), this
      # does not work anymore when the accessed URL does not match the blog's
      # base_url at least partly. Do we still want to allow acces to the blog
      # through non-standard URLs? What was the original purpose of these
      # redirects?
      describe 'and non-empty relative_url_root' do
        before do
          create(:blog, base_url: 'http://test.host/blog')
          create(:user)
        end

        it 'should redirect' do
          create(:redirect, from_path: 'foo/bar', to_path: '/someplace/else')
          get :redirect, params: { from: 'foo/bar' }
          assert_response 301
          expect(response).to redirect_to('http://test.host/blog/someplace/else')
        end

        it 'should redirect if to_path includes relative_url_root' do
          create(:redirect, from_path: 'bar/foo', to_path: '/blog/someplace/else')
          get :redirect, params: { from: 'bar/foo' }
          assert_response 301
          expect(response).to redirect_to('http://test.host/blog/someplace/else')
        end

        it 'should ignore the blog base_url if the to_path is a full uri' do
          create(:redirect, from_path: 'foo', to_path: 'http://some.where/else')
          get :redirect, params: { from: 'foo' }
          assert_response 301
          expect(response).to redirect_to('http://some.where/else')
        end
      end
    end

    it 'should get good article with utf8 slug' do
      build_stubbed(:blog)
      utf8article = create(:utf8article, permalink: 'ルビー', published_at: Time.utc(2004, 6, 2))
      get :redirect, params: { from: '2004/06/02/ルビー' }
      expect(assigns(:article)).to eq(utf8article)
    end

    # NOTE: This is needed because Rails over-unescapes glob parameters.
    it 'should get good article with pre-escaped utf8 slug using unescaped slug' do
      build_stubbed(:blog)
      utf8article = create(:utf8article, permalink: '%E3%83%AB%E3%83%93%E3%83%BC', published_at: Time.utc(2004, 6, 2))
      get :redirect, params: { from: '2004/06/02/ルビー' }
      expect(assigns(:article)).to eq(utf8article)
    end

    describe 'accessing old-style URL with "articles" as the first part' do
      it 'should redirect to article without url_root' do
        create(:blog, base_url: 'http://test.host')
        article = create(:article, permalink: 'second-blog-article', published_at: Time.utc(2004, 4, 1))
        get :redirect, params: { from: 'articles/2004/04/01/second-blog-article' }
        assert_response 301
        expect(response).to redirect_to article.permalink_url
      end

      it 'should redirect to article with url_root' do
        create(:blog, base_url: 'http://test.host/blog')
        create(:article, permalink: 'second-blog-article', published_at: Time.utc(2004, 4, 1))
        get :redirect, params: { from: 'articles/2004/04/01/second-blog-article' }
        assert_response 301
        expect(response).to redirect_to('http://test.host/blog/2004/04/01/second-blog-article')
      end

      it 'should redirect to article with articles in url_root' do
        create(:blog, base_url: 'http://test.host/aaa/articles/bbb')
        create(:article, permalink: 'second-blog-article', published_at: Time.utc(2004, 4, 1))
        get :redirect, params: { from: 'articles/2004/04/01/second-blog-article' }
        assert_response 301
        expect(response).to redirect_to('http://test.host/aaa/articles/bbb/2004/04/01/second-blog-article')
      end

      it 'should not redirect to an article from another blog'
    end

    describe 'with permalink_format like %title%.html' do
      let!(:blog) { create(:blog, permalink_format: '/%title%.html') }
      let!(:admin) { create(:user, :as_admin) }

      before do
        sign_in admin
      end

      context 'with an article' do
        let!(:article) { create(:article, permalink: 'second-blog-article', published_at: Time.utc(2004, 4, 1)) }

        context 'try redirect to an unknown location' do
          it 'raises RecordNotFound' do
            expect { get :redirect, params: { from: "#{article.permalink}/foo/bar" } }.
              to raise_error ActiveRecord::RecordNotFound
          end
        end

        describe 'accessing legacy URLs' do
          it 'should redirect from default URL format' do
            get :redirect, params: { from: '2004/04/01/second-blog-article' }
            expect(response).to redirect_to article.permalink_url
          end

          it 'should redirect from old-style URL format with "articles" part' do
            get :redirect, params: { from: 'articles/2004/04/01/second-blog-article' }
            expect(response).to redirect_to article.permalink_url
          end
        end
      end

      context 'when the article has an excerpt' do
        render_views
        let(:article) { create :article, excerpt: 'foo', body: 'bar' }

        it 'does not render a continue reading link' do
          get :redirect, params: { from: "#{article.permalink}.html" }

          aggregate_failures do
            expect(response.body).to have_text 'bar'
            expect(response.body).not_to have_text 'foo'
            expect(response.body).
              not_to have_text I18n.t!('articles.article_excerpt.continue_reading')
          end
        end
      end

      describe 'accessing an article' do
        let!(:article) { create(:article, permalink: 'second-blog-article', published_at: Time.utc(2004, 4, 1)) }
        before(:each) do
          get :redirect, params: { from: "#{article.permalink}.html" }
        end

        it 'should render template read to article' do
          expect(response).to render_template('articles/read')
        end

        it 'should assign article1 to @article' do
          expect(assigns(:article)).to eq(article)
        end

        it 'article without tags should not have meta keywords' do
          article = create(:article)
          get :redirect, params: { from: "#{article.permalink}.html" }
          expect(assigns(:keywords)).to eq('')
        end

        describe 'the resulting page' do
          render_views

          it 'should have good rss feed link' do
            expect(response.body).to have_selector("head>link[href=\"#{blog.base_url}/#{article.permalink}.html.rss\"]", visible: false)
          end

          it 'should have good atom feed link' do
            expect(response.body).to have_selector("head>link[href=\"#{blog.base_url}/#{article.permalink}.html.atom\"]", visible: false)
          end

          it 'should have a canonical url' do
            expect(response.body).to have_selector("head>link[href='#{blog.base_url}/#{article.permalink}.html']", visible: false)
          end

          it 'should have a good title' do
            expect(response.body).to have_selector('title', text: 'A big article | test blog', visible: false)
          end
        end
      end

      # TODO: Move out of permalink config context
      describe 'theme rendering' do
        render_views

        let!(:article) { create(:article, permalink: 'second-blog-article', published_at: Time.utc(2004, 4, 1)) }

        with_each_theme do |theme, _view_path|
          context "for theme #{theme}" do
            before do
              blog.theme = theme
              blog.save!
            end

            it 'renders without errors when no comments or trackbacks are present' do
              get :redirect, params: { from: "#{article.permalink}.html" }
              expect(response).to be_successful
            end

            it 'renders without errors when recaptcha is enabled' do
              Recaptcha.configure do |config|
                config.site_key = 'YourAPIkeysHere_yyyyyyyyyyyyyyyyy'
                config.secret_key = 'YourAPIkeysHere_xxxxxxxxxxxxxxxxx'
              end
              blog.use_recaptcha = true
              blog.save!
              get :redirect, params: { from: "#{article.permalink}.html" }
              expect(response).to be_successful
            end

            it 'renders without errors when comments and trackbacks are present' do
              create :trackback, article: article
              create :comment, article: article
              get :redirect, params: { from: "#{article.permalink}.html" }
              expect(response).to be_successful
            end
          end
        end
      end

      describe 'rendering as atom feed' do
        let!(:article) { create(:article, permalink: 'second-blog-article', published_at: Time.utc(2004, 4, 1)) }
        let!(:trackback1) { create(:trackback, article: article, created_at: 1.day.ago) }

        before(:each) do
          get :redirect, params: { from: "#{article.permalink}.html.atom" }
        end

        it 'should render feedback atom feed for the article' do
          expect(assigns(:article)).to eq article
          expect(response).to render_template('feedback_atom_feed', layout: false)
        end
      end

      describe 'rendering as rss feed' do
        let!(:article) { create(:article, permalink: 'second-blog-article', published_at: Time.utc(2004, 4, 1)) }
        let!(:trackback1) { create(:trackback, article: article, created_at: 1.day.ago) }

        before(:each) do
          get :redirect, params: { from: "#{article.permalink}.html.rss" }
        end

        it 'should render feedback rss feed for the article' do
          expect(assigns(:article)).to eq article
          expect(response).to render_template('feedback_rss_feed', layout: false)
        end
      end
    end

    describe 'with a format containing a fixed component' do
      let!(:blog) { create(:blog, permalink_format: '/foo/%title%') }
      let!(:article) { create(:article) }

      it 'should find the article if the url matches all components' do
        get :redirect, params: { from: "foo/#{article.permalink}" }
        expect(response).to be_successful
      end

      it 'should not find the article if the url does not match the fixed component' do
        expect { get :redirect, params: { from: "bar/#{article.permalink}" } }.
          to raise_error ActiveRecord::RecordNotFound
      end
    end

    context 'password protected' do
      render_views
      let!(:blog) { create(:blog, permalink_format: '/%title%.html') }
      let!(:article) { create(:article, password: 'password') }

      it 'article alone should be password protected' do
        get :redirect, params: { from: "#{article.permalink}.html" }
        expect(response.body).to have_selector('input[id="article_password"]', count: 1)
      end
    end
  end

  describe '#check_password' do
    render_views
    let!(:blog) { create(:blog, permalink_format: '/%title%.html') }
    let!(:article) { create(:article, password: 'password') }

    it 'shows article when given correct password' do
      get :check_password, xhr: true, params: { article: { id: article.id, password: article.password } }
      expect(response.body).not_to have_selector('input[id="article_password"]')
    end

    it 'shows password form when given incorrect password' do
      get :check_password, xhr: true, params: { article: { id: article.id, password: 'wrong password' } }
      expect(response.body).to have_selector('input[id="article_password"]')
    end
  end
end
