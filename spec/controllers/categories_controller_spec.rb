require File.dirname(__FILE__) + '/../spec_helper'

describe CategoriesController, "/index" do
  before(:each) do
    Category.stub!(:find_all_with_article_counters) \
      .and_return(mock('categories', :null_object => true))

    controller.stub!(:template_exists?) \
      .and_return(true)

    this_blog = Blog.default
    controller.stub!(:this_blog) \
      .and_return(this_blog)
  end

  def do_get
    get 'index'
  end

  it "should be successful" do
    do_get
    response.should be_success
  end

  it "should render :index" do
    do_get
    response.should render_template(:index)
  end

  it "should fall back to articles/groupings" do
    controller.should_receive(:template_exists?) \
      .with() \
      .and_return(false)
    do_get
    response.should render_template('articles/groupings')
  end
end

describe CategoriesController, '/articles/category/foo' do
  before(:each) do
    @category = mock('category', :null_object => true)
    @category.stub!(:empty?) \
      .and_return(false)

    Category.stub!(:find_by_permalink) \
      .and_return(@category)

    ActionController::Pagination::Paginator.stub!(:new) \
      .and_return(mock('pages', :null_object => true))

    controller.stub!(:template_exists?) \
      .and_return(true)
    this_blog = Blog.default
    controller.stub!(:this_blog) \
      .and_return(this_blog)
  end

  def do_get
    get 'show', :id => 'foo'
  end

  it 'should be successful' do
    do_get()
    response.should be_success
  end

  it 'should call Category.find_by_permalink' do
    Category.should_receive(:find_by_permalink) \
      .with('foo') \
      .and_return(mock('category', :null_object => true))
    do_get
  end

  it 'should render :show by default' do
    do_get
    response.should render_template(:show)
  end

  it 'should fall back to rendering articles/index' do
    controller.should_receive(:template_exists?) \
      .with() \
      .and_return(false)
    do_get
    response.should render_template('articles/index')
  end

  it 'should set the page title to "Category foo"' do
    do_get
    assigns[:page_title].should == 'Category foo, everything about foo'
  end

  it 'should render an error when the category is empty' do
    @category.should_receive(:published_articles) \
      .and_return([])

    do_get

    response.should render_template('articles/error')
    assigns[:message].should == "Can't find any articles for 'foo'"
  end

  it 'should render the atom feed for /articles/category/foo.atom' do
    get 'show', :id => 'foo', :format => 'atom'
    response.should render_template('articles/_atom_feed')
  end

  it 'should render the rss feed for /articles/category/foo.rss' do
    get 'show', :id => 'foo', :format => 'rss'
    response.should render_template('articles/_rss20_feed')
  end
end

## Old tests that still need conversion

#   def test_autodiscovery_category
#     get :category, :id => 'hardware'
#     assert_response :success
#     assert_select 'link[title=RSS]' do
#       assert_select '[rel=alternate]'
#       assert_select '[type=application/rss+xml]'
#       assert_select '[href=http://test.host/articles/category/hardware.rss]'
#     end
#     assert_select 'link[title=Atom]' do
#       assert_select '[rel=alternate]'
#       assert_select '[type=application/atom+xml]'
#       assert_select '[href=http://test.host/articles/category/hardware.atom]'
#     end
#   end
