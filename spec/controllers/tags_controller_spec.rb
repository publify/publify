require 'spec_helper'

describe TagsController, "/index" do
  render_views

  before do
    Factory(:blog)
    3.times {
      tag = Factory(:tag)
      2.times { tag.articles << Factory(:article) }
    }
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

      do_get
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
      @tag.articles << Factory(:article)
      @tag.articles << Factory(:article)
    end

    it 'should be successful' do
      do_get()
      response.should be_success
    end

    it 'should retrieve the correct set of articles' do
      pending "Doesn't seem to work"
      do_get
      assigns[:articles].should == @tag.articles
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
      assigns[:page_title].should == 'Tag foo, everything about Foo'
    end

    it 'should render the atom feed for /articles/tag/foo.atom' do
      get 'show', :id => 'foo', :format => 'atom'
      response.should render_template('articles/_atom_feed')
    end

    it 'should render the rss feed for /articles/tag/foo.rss' do
      get 'show', :id => 'foo', :format => 'rss'
      response.should render_template('articles/_rss20_feed')
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
end

describe TagsController, "showing a non-existant tag" do
  # TODO: Perhaps we can show something like 'Nothing tagged with this tag'?
  it 'should redirect to main page' do
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
