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

  integrate_views

  before(:each) do
    IPSocket.stub!(:getaddress).and_return do
      raise SocketError.new("getaddrinfo: Name or service not known")
    end
    CachedModel.cache_reset
    controller.send(:reset_blog_ids)
  end

  it "should redirect category to /categories" do
    get 'category'
    response.should redirect_to(categories_path)
  end

  it "should redirect tag to /tags" do
    get 'tag'
    response.should redirect_to(tags_path)
  end

  describe 'index action' do
    before :each do
      get 'index'
    end

    it 'should be render template index' do
      response.should render_template(:index)
    end

    it 'should assigns articles' do
      assigns[:articles].should_not be_nil
    end

    it 'should have good link feed rss' do
      response.should have_tag('head>link[href=?]','http://test.host/articles.rss')
    end

    it 'should have good link feed atom' do
      response.should have_tag('head>link[href=?]','http://test.host/articles.atom')
    end
  end


  describe '#search action' do

    describe 'a valid research' do
      before :each do
        get 'search', :q => 'a'
      end

      it 'should render template search' do
        response.should render_template(:search)
      end

      it 'should assigns articles' do
        assigns[:articles].should_not be_nil
      end

      it 'should have good feed rss link' do
        response.should have_tag('head>link[href=?]','http://test.host/search/a.rss')
      end

      it 'should have good feed atom link' do
        response.should have_tag('head>link[href=?]','http://test.host/search/a.atom')
      end

    end

    it 'should render feed rss by search' do
      get 'search', :q => 'a', :format => 'rss'
      response.should be_success
      response.should render_template('articles/_rss20_feed')
    end

    it 'should render feed atom by search' do
      get 'search', :q => 'a', :format => 'atom'
      response.should be_success
      response.should render_template('articles/_atom_feed')
    end

    it 'search with empty result' do
      get 'search', :q => 'abcdefghijklmnopqrstuvwxyz'
      response.should render_template('articles/error.html.erb')
      assigns[:articles].should be_empty
    end
  end

  
  it 'archives' do
    get 'archives'
    response.should render_template(:archives)
    assigns[:articles].should_not be_nil
  end

end

describe ArticlesController, "feeds" do
  
  integrate_views

  before do
    @mock = mock('everything', :null_object => true)
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
    response.should have_tag('link', 'http://test.host/articles.rss')
  end

  def scoped_getter
    with_options(:year => 2007, :month => 10, :day => 11, :id => 'slug') { |item| item }
  end

  specify "/yyyy/mm/dd/slug.atom should be an atom feed" do
    scoped_getter.get 'index', :format => 'atom'
    response.should render_template("_atom_feed")
  end

  specify "/yyyy/mm/dd/slug.rss should be an rss20 feed" do
    scoped_getter.get 'index', :format => 'rss'
    response.should render_template("_rss20_feed")
  end

  it 'should not render &eacute; in atom feed' do
    article = contents(:article2)
    article.body = '&eacute;coute The future is cool!'
    article.save!
    get 'index', :format => 'atom'
    response.body.should =~ /écoute The future is cool!/
  end
end
