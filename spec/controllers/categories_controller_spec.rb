require 'spec_helper'

describe CategoriesController, "/index" do
  before do
    Factory(:blog)
    3.times {
      category = Factory(:category)
      2.times { category.articles << Factory(:article) }
    }
  end

  describe "normally" do
    before do
      controller.stub(:template_exists?).and_return false
      get 'index'
    end

    specify { response.should be_success }
    specify { response.should render_template('articles/groupings') }
    specify { assigns(:groupings).should_not be_empty }

    describe "when rendered" do
      render_views

      specify { response.body.should have_selector('ul.categorylist') }
    end
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

describe CategoriesController, '#show' do
  before do
    blog = Factory(:blog, :base_url => "http://myblog.net", :theme => "typographic",
                      :use_canonical_url => true, :blog_name => "My Shiny Weblog!")
    Blog.stub(:default) { blog }
    Trigger.stub(:fire) { }

    category = Factory(:category, :permalink => 'personal', :name => 'Personal')
    2.times {|i| Factory(:article, :published_at => Time.now, :categories => [category]) }
    Factory(:article, :published_at => nil)
  end

  def do_get
    get 'show', :id => 'personal'
  end

  it 'should be successful' do
    do_get
    response.should be_success
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
  
  it 'should render personal when template exists' do
    pending "Stubbing #template_exists is not enough to fool Rails"
    controller.stub!(:template_exists?) \
      .and_return(true)
    do_get
    response.should render_template('personal')
  end  

  it 'should show only published articles' do
    do_get
    assigns(:articles).size.should == 2
  end

  it 'should set the page title to "Category Personal"' do
    do_get
    assigns[:page_title].should == 'Category: Personal | My Shiny Weblog! '
  end

  describe "when rendered" do
    render_views
  
    it 'should have a canonical URL' do
      do_get
      response.should have_selector('head>link[href="http://myblog.net/category/personal/"]')
    end
  end

  it 'should render the atom feed for /articles/category/personal.atom' do
    get 'show', :id => 'personal', :format => 'atom'
    response.should render_template('articles/index_atom_feed')
    @layouts.keys.compact.should be_empty
  end

  it 'should render the rss feed for /articles/category/personal.rss' do
    get 'show', :id => 'personal', :format => 'rss'
    response.should render_template('articles/index_rss_feed')
    @layouts.keys.compact.should be_empty
  end
end

describe CategoriesController, "#show with a non-existent category" do
  before do
    blog = stub_model(Blog, :base_url => "http://myblog.net", :theme => "typographic",
                      :use_canonical_url => true)
    Blog.stub(:default) { blog }
    Trigger.stub(:fire) { }
  end

  it 'should raise ActiveRecord::RecordNotFound' do
    Category.should_receive(:find_by_permalink) \
      .with('foo').and_raise(ActiveRecord::RecordNotFound)
    lambda do
      get 'show', :id => 'foo'
    end.should raise_error(ActiveRecord::RecordNotFound)
  end
end

describe CategoriesController, 'empty category life-on-mars' do
  it 'should redirect to home when the category is empty' do
    Factory(:blog)
    Factory(:category, :permalink => 'life-on-mars')
    get 'show', :id => 'life-on-mars'
    response.status.should == 301
    response.should redirect_to(Blog.default.base_url)
  end
end

describe CategoriesController, "password protected article" do
  render_views

  it 'should be password protected when shown in category' do
    Factory(:blog)
    cat = Factory(:category, :permalink => 'personal')
    cat.articles << Factory(:article, :password => 'my_super_pass')
    cat.save!

    get 'show', :id => 'personal'

    assert_tag :tag => "input",
      :attributes => { :id => "article_password" }
  end  
end

describe CategoriesController, "SEO Options" do
  render_views

  it 'category without meta keywords and activated options (use_meta_keyword ON) should not have meta keywords' do
    Factory(:blog, :use_meta_keyword => true)
    cat = Factory(:category, :permalink => 'personal')
    Factory(:article, :categories => [cat])
    get 'show', :id => 'personal'
    response.should_not have_selector('head>meta[name="keywords"]')
  end

  it 'category with keywords and activated option (use_meta_keyword ON) should have meta keywords' do
    Factory(:blog, :use_meta_keyword => true)
    after_build_category_should_have_selector('head>meta[name="keywords"]')
  end

  it 'category with meta keywords and deactivated options (use_meta_keyword off) should not have meta keywords' do
    Factory(:blog, :use_meta_keyword => false)
    after_build_category_should_not_have_selector('head>meta[name="keywords"]')
  end

  it 'with unindex_categories (set ON), should have rel nofollow' do
    Factory(:blog, :unindex_categories => true)
    after_build_category_should_have_selector('head>meta[content="noindex, follow"]')
  end

  it 'without unindex_categories (set OFF), should not have rel nofollow' do
    Factory(:blog, :unindex_categories => false)
    after_build_category_should_not_have_selector('head>meta[content="noindex, follow"]')
  end

  def after_build_category_should_have_selector expected
    cat = Factory(:category, :permalink => 'personal', :keywords => "some, keywords")
    Factory(:article, :categories => [cat])
    get 'show', :id => 'personal'
    response.should have_selector(expected)
  end

  def after_build_category_should_not_have_selector expected
    cat = Factory(:category, :permalink => 'personal', :keywords => "some, keywords")
    Factory(:article, :categories => [cat])
    get 'show', :id => 'personal'
    response.should_not have_selector(expected)
  end
end
