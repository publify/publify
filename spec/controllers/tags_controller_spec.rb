require 'spec_helper'

describe TagsController, "/index" do
  render_views

  before do
    Factory(:blog)
    Factory(:tag).articles << Factory(:article)
  end

  describe "normally" do
    before do
      get 'index'
    end

    specify { response.should be_success }
    specify { response.should render_template('articles/groupings') }
    specify { assigns(:groupings).should_not be_empty }
    specify { response.body.should have_selector('ul.tags[id="taglist"]') }
  end

  describe "if :index template exists" do
    it "should render :index" do
      pending "Stubbing #template_exists is not enough to fool Rails"
      controller.stub!(:template_exists?) \
        .and_return(true)

      get 'index'
      response.should render_template(:index)
    end
  end
end

describe TagsController, 'showing a single tag' do
  before do
    Factory(:blog)
    @tag = Factory(:tag, :name => 'Foo')
  end

  def do_get
    get 'show', :id => 'foo'
  end

  describe "with some articles" do
    before do
      @articles = 2.times.map { Factory(:article) }
      @tag.articles << @articles
    end

    it 'should be successful' do
      do_get()
      response.should be_success
    end

    it 'should retrieve the correct set of articles' do
      do_get
      assigns[:articles].map(&:id).sort.should == @articles.map(&:id).sort
    end

    it 'should render :show by default' do
      pending "Stubbing #template_exists is not enough to fool Rails"
      controller.stub!(:template_exists?) \
        .and_return(true)
      do_get
      response.should render_template(:show)
    end

    it 'should fall back to rendering articles/index' do
      controller.stub!(:template_exists?) \
        .and_return(false)
      do_get
      response.should render_template('articles/index')
    end

    it 'should set the page title to "Tag foo"' do
      do_get
      assigns[:page_title].should == 'Tag: foo | test blog '
    end

    it 'should render the atom feed for /articles/tag/foo.atom' do
      get 'show', :id => 'foo', :format => 'atom'
      response.should render_template('articles/index_atom_feed')
      @layouts.keys.compact.should be_empty
    end

    it 'should render the rss feed for /articles/tag/foo.rss' do
      get 'show', :id => 'foo', :format => 'rss'
      response.should render_template('articles/index_rss_feed')
      @layouts.keys.compact.should be_empty
    end
  end

  describe "without articles" do
    # TODO: Perhaps we can show something like 'Nothing tagged with this tag'?
    it 'should redirect to main page' do
      do_get

      response.status.should == 301
      response.should redirect_to(Blog.default.base_url)
    end
  end
end

describe TagsController, 'showing tag "foo"' do
  render_views

  before(:each) do
    Factory(:blog)
    #TODO need to add default article into tag_factory build to remove this :articles =>...
    foo = Factory(:tag, :name => 'foo', :articles => [Factory(:article)])
    get 'show', :id => 'foo'
  end

  it 'should have good rss feed link in head' do
    response.should have_selector('head>link[href="http://test.host/tag/foo.rss"][rel=alternate][type="application/rss+xml"][title=RSS]')
  end

  it 'should have good atom feed link in head' do
    response.should have_selector('head>link[href="http://test.host/tag/foo.atom"][rel=alternate][type="application/atom+xml"][title=Atom]')
  end
  
  it 'should have a canonical URL' do
    response.should have_selector('head>link[href="http://myblog.net/tag/foo/"]')
  end
end

describe TagsController, "showing a non-existant tag" do
  # TODO: Perhaps we can show something like 'Nothing tagged with this tag'?
  it 'should redirect to main page' do
    Factory(:blog)
    get 'show', :id => 'thistagdoesnotexist'

    response.status.should == 301
    response.should redirect_to(Blog.default.base_url)
  end
end

describe TagsController, "password protected article" do
  render_views

  it 'article in tag should be password protected' do
    Factory(:blog)
    #TODO need to add default article into tag_factory build to remove this :articles =>...
    a = Factory(:article, :password => 'password')
    foo = Factory(:tag, :name => 'foo', :articles => [a])
    get 'show', :id => 'foo'
    assert_tag :tag => "input",
      :attributes => { :id => "article_password" }
  end
end

describe TagsController, "SEO Options" do
  render_views
  
  before(:each) do 
    @blog = Factory(:blog)
    @a = Factory(:article)
    @foo = Factory(:tag, :name => 'foo', :articles => [@a])
  end
  
  it 'should have rel nofollow' do
    @blog.unindex_tags = true
    @blog.save
    
    get 'show', :id => 'foo'
    response.should have_selector('head>meta[content="noindex, follow"]')
  end

  it 'should not have rel nofollow' do
    @blog.unindex_tags = false
    @blog.save
    
    get 'show', :id => 'foo'
    response.should_not have_selector('head>meta[content="noindex, follow"]')
  end
  # meta_keywords
  
  it 'should not have meta keywords with deactivated option and no blog keywords' do
    @blog.use_meta_keyword = false
    @blog.save
    get 'show', :id => 'foo'
    response.should_not have_selector('head>meta[name="keywords"]')
  end

  it 'should not have meta keywords with deactivated option and blog keywords' do
    @blog.use_meta_keyword = false
    @blog.meta_keywords = "foo, bar, some, keyword"
    @blog.save
    get 'show', :id => 'foo'
    response.should_not have_selector('head>meta[name="keywords"]')
  end

  it 'should not have meta keywords with activated option and no blog keywords' do
    @blog.use_meta_keyword = true
    @blog.save
    get 'show', :id => 'foo'
    response.should_not have_selector('head>meta[name="keywords"]')
  end

  it 'should have meta keywords with activated option and blog keywords' do
    @blog.use_meta_keyword = true
    @blog.meta_keywords = "foo, bar, some, keyword"
    @blog.save
    get 'show', :id => 'foo'
    response.should have_selector('head>meta[name="keywords"]')
  end

end
