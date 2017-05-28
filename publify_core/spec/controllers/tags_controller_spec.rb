require 'rails_helper'

RSpec.describe TagsController, type: :controller do
  describe '#index' do
    before do
      create(:blog)
      @tag = create(:tag)
      @tag.articles << create(:article)
    end

    describe 'normally' do
      before do
        get 'index'
      end

      specify { expect(response).to be_success }
      specify { expect(response).to render_template('tags/index') }
      specify { expect(assigns(:tags)).to match_array([@tag]) }
    end

    describe 'with views rendered' do
      render_views

      it 'works' do
        get 'index'
      end
    end
  end

  describe 'showing a single tag' do
    before do
      create(:blog)
      @tag = create(:tag, name: 'Foo')
    end

    def do_get
      get 'show', params: { id: 'foo' }
    end

    describe 'with some articles' do
      before do
        @articles = create_list :article, 2
        @tag.articles << @articles
      end

      it 'should be successful' do
        do_get
        expect(response).to be_success
      end

      it 'should retrieve the correct set of articles' do
        do_get
        expect(assigns[:articles].map(&:id).sort).to eq(@articles.map(&:id).sort)
      end

      it 'should render :show by default' do
        do_get
        expect(response).to render_template(:show)
      end

      it 'should render the tag template if present' do
        # NOTE: Stubbing Object under test :-(.
        allow(controller).to receive(:template_exists?).and_return(true)
        allow(controller).to receive(:render)
        do_get
        expect(controller).to have_received(:render).with('foo')
      end

      it 'should set the page title to "Tag foo"' do
        do_get
        expect(assigns[:page_title]).to eq('Tag: foo | test blog ')
      end

      it 'should render the atom feed for /articles/tag/foo.atom' do
        get 'show', params: { id: 'foo', format: 'atom' }
        expect(response).to render_template('articles/index_atom_feed', layout: false)
      end

      it 'should render the rss feed for /articles/tag/foo.rss' do
        get 'show', params: { id: 'foo', format: 'rss' }
        expect(response).to render_template('articles/index_rss_feed', layout: false)
      end
    end

    describe 'without articles' do
      it 'raises RecordNotFound' do
        expect { get 'show', params: { id: 'foo' } }.
          to raise_error ActiveRecord::RecordNotFound
      end
    end
  end

  describe 'showing tag "foo"' do
    render_views

    let!(:blog) { create(:blog) }
    let(:parsed_body) { Capybara.string(response.body) }

    before(:each) do
      create(:tag, name: 'foo', articles: [create(:article)])
      get 'show', params: { id: 'foo' }
    end

    it 'should have good rss feed link in head' do
      rss_link = parsed_body.find "head>link[href='http://test.host/tag/foo.rss']", visible: false
      aggregate_failures do
        expect(rss_link['rel']).to eq 'alternate'
        expect(rss_link['type']).to eq 'application/rss+xml'
        expect(rss_link['title']).to eq 'RSS'
      end
    end

    it 'should have good atom feed link in head' do
      atom_link = parsed_body.find "head>link[href='http://test.host/tag/foo.atom']", visible: false
      aggregate_failures do
        expect(atom_link['rel']).to eq 'alternate'
        expect(atom_link['type']).to eq 'application/atom+xml'
        expect(atom_link['title']).to eq 'Atom'
      end
    end

    it 'should have a canonical URL' do
      expect(response.body).to have_selector("head>link[href='#{blog.base_url}/tag/foo']", visible: false)
    end
  end

  describe 'showing a non-existant tag' do
    it 'should signal not found' do
      create(:blog)
      expect { get 'show', params: { id: 'thistagdoesnotexist' } }.
        to raise_error ActiveRecord::RecordNotFound
    end
  end

  describe 'password protected article' do
    render_views

    it 'article in tag should be password protected' do
      create(:blog)
      article = create(:article, password: 'password')
      create(:tag, name: 'foo', articles: [article])
      get 'show', params: { id: 'foo' }
      assert_select('input[id="article_password"]')
    end
  end

  describe 'SEO Options' do
    before(:each) do
      @blog = create(:blog)
      @a = create(:article)
      @foo = create(:tag, name: 'foo', articles: [@a])
    end

    describe 'keywords' do
      it 'does not assign keywords when the blog has no keywords' do
        get 'show', params: { id: 'foo' }

        expect(assigns(:keywords)).to eq ''
      end

      it "assigns the blog's keywords if present" do
        @blog.meta_keywords = 'foo, bar'
        @blog.save
        get 'show', params: { id: 'foo' }
        expect(assigns(:keywords)).to eq 'foo, bar'
      end
    end
  end
end
