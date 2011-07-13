require 'spec_helper'

describe CategoriesController, "/index" do
  render_views

  describe "normally" do
    before do
      Factory(:blog)
      cat = Factory.build(:category) 
      cat_p = [cat]
      cat_p.stub!(:total_pages).and_return(1)
      Category.should_receive(:paginate).and_return(cat_p)
      get 'index'
    end

    specify { response.should be_success }
    specify { response.should render_template('articles/groupings') }
    specify { assigns(:groupings).should_not be_empty }
    specify { response.body.should have_selector('ul.categorylist') }
  end

  describe "if :index template exists" do
    
    it "should render :index" do
      Factory(:blog)
      3.times {
        category = Factory(:category)
        2.times { category.articles << Factory(:article) }
      }
      pending "Stubbing #template_exists is not enough to fool Rails"
      controller.stub!(:template_exists?) \
        .and_return(true)

      do_get
      response.should render_template(:index)
    end
  end
end

describe CategoriesController, '/articles/category/personal' do
  render_views
  
  before do
    Factory(:blog)
    cat = Factory(:category, :permalink => 'personal', :name => 'Personal')
    cat.articles << Factory(:article)
    cat.articles << Factory(:article)
    cat.articles << Factory(:article)
    cat.articles << Factory(:article)
  end

  def do_get
    get 'show', :id => 'personal'
  end

  it 'should be successful' do
    c = Factory.build(:category, :permalink => 'personal')
    articles = [Factory.build(:article, :categories => [c])]
    controller.should_receive(:show_page_title_for)
    controller.should_receive(:permalink_with_page)
    Category.should_receive(:find_by_permalink).with('personal').and_return(c)
    c.should_receive(:published_articles).and_return(articles)
    do_get
    response.should be_success
  end

  it 'should raise ActiveRecord::RecordNotFound' do
    Category.should_receive(:find_by_permalink) \
      .with('personal').and_raise(ActiveRecord::RecordNotFound)
    lambda do
      do_get
    end.should raise_error(ActiveRecord::RecordNotFound)
  end

  it 'should render :show by default'
  if false
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

  it 'should show only published articles' do
    c = Factory.build(:category, :permalink => 'Social')
    articles = [Factory.build(:article, :categories => [c])]
    controller.should_receive(:show_page_title_for)
    controller.should_receive(:permalink_with_page)
    Category.should_receive(:find_by_permalink).with('Social').and_return(c)
    c.should_receive(:published_articles).and_return(articles)
    get 'show', :id => 'Social'
    response.should be_success
    assigns[:articles].should_not be_empty
  end

  it 'should set the page title to "Category Personal"' do
    do_get
    assigns[:page_title].should == 'Category Personal, everything about Personal'
    response.should have_selector('head>link[href="http://myblog.net/category/personal/"]')
  end

  it 'should have a canonical URL' do
    c = Factory.build(:category, :permalink => 'personal')
    art = Factory.build(:article, :categories => [c])
    controller.should_receive(:show_page_title_for)
    controller.should_receive(:permalink_with_page).and_return('http://myblog.net/category/personal/')
    Category.should_receive(:find_by_permalink).with('personal').and_return(c)
    c.should_receive(:published_articles).and_return([art])
   
    do_get
    response.should have_selector('head>link[href="http://myblog.net/category/personal/"]')
  end

  it 'should render the atom feed for /articles/category/personal.atom' do
    get 'show', :id => 'personal', :format => 'atom'
    response.should render_template('shared/_atom_feed')
  end

  it 'should render the rss feed for /articles/category/personal.rss' do
    get 'show', :id => 'personal', :format => 'rss'
    response.should render_template('shared/_rss20_feed')
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

  before(:each) do 
    @blog = Factory(:blog)
    @cat = Factory(:category, :permalink => 'personal')
    @cat.articles << Factory(:article)
    @cat.save!
  end

  it 'should have rel nofollow' do
    @blog.unindex_categories = true
    @blog.save
    
    get 'show', :id => 'personal'
    response.should have_selector('head>meta[content="noindex, follow"]')
  end

  it 'should not have rel nofollow' do
    @blog.unindex_categories = false
    @blog.save

    get 'show', :id => 'personal'
    response.should_not have_selector('head>meta[content="noindex, follow"]')
  end
  
  describe "with meta_keyword usage" do
    before do
      @blog.use_meta_keyword = true
      @blog.save
    end

    it 'category with keywords and activated option should have meta keywords' do
      cat = Factory.build(:category, :permalink => 'personal', :keywords => "some, keywords")
      art = Factory.build(:article, :categories => [cat])
      Category.should_receive(:find_by_permalink).with('personal').and_return(cat)
      cat.should_receive(:published_articles).and_return([art])
    
      get 'show', :id => 'personal'
      response.should have_selector('head>meta[name="keywords"]')
    end
 
    it 'category without meta keywords and activated should not have meta keywords' do
      get 'show', :id => 'personal'
      response.should_not have_selector('head>meta[name="keywords"]')
    end
    
    it 'category without meta keywords and activated options should not have meta keywords' do
      get 'show', :id => 'personal'
      response.should_not have_selector('head>meta[name="keywords"]')
    end

  end

    it 'category with meta keywords and deactivated options should not have meta keywords' do
      @blog.use_meta_keyword = false
      @blog.save
      @cat.keywords = "some, keywords"
      @cat.save
    
      get 'show', :id => 'personal'
      response.should_not have_selector('head>meta[name="keywords"]')
    end
end
