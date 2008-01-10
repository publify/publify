require File.dirname(__FILE__) + '/../spec_helper'

class Content
  def self.find_last_posted
    find(:first, :conditions => ['created_at < ?', Time.now],
         :order => 'created_at DESC')
  end
end

describe 'ArticlesController' do
  controller_name :articles
  Article.delete_all

  before(:each) do
    IPSocket.stub!(:getaddress).and_return do
      raise SocketError.new("getaddrinfo: Name or service not known")
    end
    CachedModel.cache_reset
    controller.send(:reset_blog_ids)
  end

  it "should redirect category to /articles/categories" do
    get 'category'
    response.should redirect_to(categories_path)
  end

  it "should redirect tag to /articles/tags" do
    get 'tag'
    response.should redirect_to(tags_path)
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
