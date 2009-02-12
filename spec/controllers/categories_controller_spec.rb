require File.dirname(__FILE__) + '/../spec_helper'

describe CategoriesController, "/index" do
  before(:each) do
    controller.stub!(:template_exists?) \
      .and_return(true)
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

describe CategoriesController, '/articles/category/personal' do
  before(:each) do
    controller.stub!(:template_exists?) \
      .and_return(true)
  end

  def do_get
    get 'show', :id => 'personal'
  end

  it 'should be successful' do
    do_get()
    response.should be_success
  end

  it 'should call Category.find_by_permalink' do
    Category.should_receive(:find_by_permalink) \
      .with('personal') \
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

  it 'should show only published articles' do
    c = categories(:personal)
    c.articles.size.should == 4
    c.published_articles.size.should == 3

    get 'show', :id => 'personal'

    response.should be_success
    assigns[:articles].size.should == 3
  end

  it 'should set the page title to "Category personal"' do
    do_get
    assigns[:page_title].should == 'Category personal, everything about personal'
  end

  it 'should render the atom feed for /articles/category/personal.atom' do
    get 'show', :id => 'personal', :format => 'atom'
    response.should render_template('articles/_atom_feed')
  end

  it 'should render the rss feed for /articles/category/personal.rss' do
    get 'show', :id => 'personal', :format => 'rss'
    response.should render_template('articles/_rss20_feed')
  end

end

describe CategoriesController, 'empty category life-on-mars' do
  it 'should redirect to home when the category is empty' do
    get 'show', :id => 'life-on-mars'

    response.status.should == "301 Moved Permanently"
    response.should redirect_to(Blog.default.base_url)
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
