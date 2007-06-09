require File.dirname(__FILE__) + '/../spec_helper'

class Content
  def self.find_last_posted
    find(:first, :conditions => ['created_at < ?', Time.now],
         :order => 'created_at DESC')
  end
end

describe 'ArticlesController' do
  controller_name :articles
  fixtures(:contents, :feedback, :categories, :blogs, :users, :categorizations,
           :text_filters, :articles_tags, :tags, :blacklist_patterns, :resources,
           :sidebars)

  before(:each) do
    IPSocket.stub!(:getaddress).and_return do
      raise SocketError.new("getaddrinfo: Name or service not known")
    end
    CachedModel.cache_reset
  end

  it 'can get a category when permalink == name' do
    get 'category', :id => 'software'

    assigns[:page_title].should == 'category software'
    response.should render_template('index')
  end

  it 'can get a category index when permalink != name' do
    get 'category', :id => 'weird-permalink'

    assigns[:page_title].should == "category weird-permalink"
    response.should render_template('index')
  end

  it 'can get an empty category' do
    get 'category', :id => 'life-on-mars'
    response.should render_template('error')
    assigns[:message].should == "Can't find posts with category 'life-on-mars'"
  end


  it 'index' do
    get 'index'
    response.should render_template(:index)
    assigns[:pages].should_not be_nil
    assigns[:articles].should_not be_nil
  end
end

describe ArticlesController, "feeds" do
  before do
    @mock = mock('everything', :null_object => true)
    Blog.stub!(:find).and_return(@mock)
    Category.stub!(:find_by_permalink).and_return(@mock)
    Tag.stub!(:find_by_permalink).and_return(@mock)
    User.stub!(:find_by_permalink).and_return(@mock)
  end

  specify "/articles.atom => an atom feed" do
    get 'index', :format => 'atom'
    response.should be_success
    response.should render_template("_atom_feed")
  end

  specify "/articles.rss => an RSS 2.0 feed" do
    get 'index', :format => 'rss'
    response.should be_success
    response.should render_template("_rss20_feed")
  end

  specify "articles/category/foo.atom => atom feed" do
    get 'category', :id => 'foo', :format => 'atom'
    response.should render_template("_atom_feed")
  end

  specify "articles/category/foo.rss => rss feed" do
    get 'category', :id => 'foo', :format => 'rss'
    response.should render_template("_rss20_feed")
  end

  specify "articles/tag/foo.atom => atom feed" do
    get 'tag', :id => 'foo', :format => 'atom'
    response.should render_template("_atom_feed")
  end

  specify "articles/tag/foo.rss => rss feed" do
    get 'tag', :id => 'foo', :format => 'rss'
    response.should render_template("_rss20_feed")
  end

  specify "articles/author/foo.atom => atom feed" do
    get 'author', :id => 'foo', :format => 'atom'
    response.should render_template("_atom_feed")
  end

  specify "articles/author/foo.rss => rss feed" do
    get 'author', :id => 'foo', :format => 'rss'
    response.should render_template("_rss20_feed")
  end

  def scoped_getter
    with_options(:year => 2007, :month => 10, :day => 11, :id => 'slug') { |item| item }
  end

  specify "/articles/yyyy/mm/dd/slug.atom should be an atom feed" do
    scoped_getter.get 'index', :format => 'atom'
    response.should render_template("_atom_feed")
  end

  specify "/articles/yyyy/mm/dd/slug.rss should be an rss20 feed" do
    scoped_getter.get 'index', :format => 'rss'
    response.should render_template("_rss20_feed")
  end
end
