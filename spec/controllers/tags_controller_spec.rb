require 'spec_helper'

describe TagsController, "/index" do
  before do
    create(:blog)
    @tag = create(:tag)
    @tag.articles << create(:article)
  end

  describe "normally" do
    before do
      get 'index'
    end

    specify { response.should be_success }
    specify { response.should render_template('tags/index') }
    specify { assigns(:tags).should =~ [@tag] }
  end
end

describe TagsController, 'showing a single tag' do
  before do
    FactoryGirl.create(:blog)
    @tag = FactoryGirl.create(:tag, :name => 'Foo')
  end

  def do_get
    get 'show', :id => 'foo'
  end

  describe "with some articles" do
    before do
      @articles = 2.times.map { FactoryGirl.create(:article) }
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
      controller.stub(:template_exists?) \
        .and_return(true)
      do_get
      response.should render_template(:show)
    end

    it 'should fall back to rendering articles/index' do
      controller.stub(:template_exists?) \
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
    FactoryGirl.create(:blog)
    #TODO need to add default article into tag_factory build to remove this :articles =>...
    foo = FactoryGirl.create(:tag, :name => 'foo', :articles => [FactoryGirl.create(:article)])
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
    FactoryGirl.create(:blog)
    get 'show', :id => 'thistagdoesnotexist'

    response.status.should == 301
    response.should redirect_to(Blog.default.base_url)
  end
end

describe TagsController, "password protected article" do
  render_views

  it 'article in tag should be password protected' do
    FactoryGirl.create(:blog)
    #TODO need to add default article into tag_factory build to remove this :articles =>...
    a = FactoryGirl.create(:article, :password => 'password')
    foo = FactoryGirl.create(:tag, :name => 'foo', :articles => [a])
    get 'show', :id => 'foo'
    assert_tag :tag => "input",
      :attributes => { :id => "article_password" }
  end
end

describe TagsController, "SEO Options" do
  before(:each) do
    @blog = FactoryGirl.create(:blog)
    @a = FactoryGirl.create(:article)
    @foo = FactoryGirl.create(:tag, :name => 'foo', :articles => [@a])
  end

  describe "keywords" do
    it 'does not assign keywords when the blog has no keywords' do
      get 'show', :id => 'foo'

      assigns(:keywords).should eq ""
    end

    it "assigns the blog's keywords if present" do
      @blog.meta_keywords = "foo, bar"
      @blog.save
      get 'show', :id => 'foo'
      assigns(:keywords).should eq "foo, bar"
    end
  end
end
