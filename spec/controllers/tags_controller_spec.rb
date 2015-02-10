describe TagsController, '/index', type: :controller do
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
end

describe TagsController, 'showing a single tag', type: :controller do
  before do
    FactoryGirl.create(:blog)
    @tag = FactoryGirl.create(:tag, name: 'Foo')
  end

  def do_get
    get 'show', id: 'foo'
  end

  describe 'with some articles' do
    before do
      @articles = 2.times.map { FactoryGirl.create(:article) }
      @tag.articles << @articles
    end

    it 'should be successful' do
      do_get()
      expect(response).to be_success
    end

    it 'should retrieve the correct set of articles' do
      do_get
      expect(assigns[:articles].map(&:id).sort).to eq(@articles.map(&:id).sort)
    end

    it 'should fall back to rendering articles/index' do
      allow(controller).to receive(:template_exists?) \
        .and_return(false)
      do_get
      expect(response).to render_template('articles/index')
    end

    it 'should set the page title to "Tag foo"' do
      do_get
      expect(assigns[:page_title]).to eq('Tag: foo | test blog ')
    end

    it 'should render the atom feed for /articles/tag/foo.atom' do
      get 'show', id: 'foo', format: 'atom'
      expect(response).to render_template('articles/index_atom_feed', layout: false)
    end

    it 'should render the rss feed for /articles/tag/foo.rss' do
      get 'show', id: 'foo', format: 'rss'
      expect(response).to render_template('articles/index_rss_feed', layout: false)
    end
  end

  describe 'without articles' do
    # TODO: Perhaps we can show something like 'Nothing tagged with this tag'?
    it 'should redirect to main page' do
      do_get

      expect(response.status).to eq(301)
      expect(response).to redirect_to(Blog.default.base_url)
    end
  end
end

describe TagsController, 'showing a non-existant tag', type: :controller do
  # TODO: Perhaps we can show something like 'Nothing tagged with this tag'?
  it 'should redirect to main page' do
    FactoryGirl.create(:blog)
    get 'show', id: 'thistagdoesnotexist'

    expect(response.status).to eq(301)
    expect(response).to redirect_to(Blog.default.base_url)
  end
end

describe TagsController, 'SEO Options', type: :controller do
  before(:each) do
    @blog = FactoryGirl.create(:blog)
    @a = FactoryGirl.create(:article)
    @foo = FactoryGirl.create(:tag, name: 'foo', articles: [@a])
  end

  describe 'keywords' do
    it 'does not assign keywords when the blog has no keywords' do
      get 'show', id: 'foo'

      expect(assigns(:keywords)).to eq ''
    end

    it "assigns the blog's keywords if present" do
      @blog.meta_keywords = 'foo, bar'
      @blog.save
      get 'show', id: 'foo'
      expect(assigns(:keywords)).to eq 'foo, bar'
    end
  end
end
