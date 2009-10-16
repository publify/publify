require File.dirname(__FILE__) + '/../spec_helper'

describe ArticlesController do
  integrate_views

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

    describe 'a valid search' do
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

      it 'should have content markdown interpret and without html tag' do
        response.should have_tag('div', /in markdown format\n\n\nwe\nuse\nok to define a link\n\n...\n/)
      end

    end

    it 'should render feed rss by search' do
      get 'search', :q => 'a', :format => 'rss'
      response.should be_success
      response.should render_template('articles/_rss20_feed')
      assert_feedvalidator response.body
    end

    it 'should render feed atom by search' do
      get 'search', :q => 'a', :format => 'atom'
      response.should be_success
      response.should render_template('articles/_atom_feed')
      assert_feedvalidator response.body
    end

    it 'search with empty result' do
      get 'search', :q => 'abcdefghijklmnopqrstuvwxyz'
      response.should render_template('articles/error.html.erb')
      assigns[:articles].should be_empty
    end
  end

  describe '#livesearch action' do

    describe 'with a query with several words' do

      before :each do
        Factory.create(:article, :body => "hello world and im herer")
        Factory.create(:article, :title => "hello", :body => "worldwide")
        Factory.create(:article)
        get :live_search, :q => 'hello world'
      end

      it 'should be valid' do 
        assigns[:articles].should_not be_empty
        assigns[:articles].should have(2).records
      end

      it 'should render without layout' do
        controller.should_receive(:render).with(:layout =>false, :action => :live_search)
        get :live_search, :q => 'hello world'
      end

      it 'should render template live_search' do
        response.should render_template(:live_search)
      end

      it 'should not have h3 tag' do
        response.should have_tag("h3")
      end

      it "should assign @search the search string" do
        assigns[:search].should be_equal(params[:q])
      end

    end
  end

  
  it 'archives' do
    get 'archives'
    response.should render_template(:archives)
    assigns[:articles].should_not be_nil
  end

  describe 'index for a month' do

    before :each do
      get 'index', :year => 2004, :month => 4
    end

    it 'should render template index' do
      response.should render_template(:index)
    end

    it 'should contain some articles' do
      assigns[:articles].should_not be_nil
    end
  end

end

describe ArticlesController, "feeds" do
  
  integrate_views

  specify "/articles.atom => an atom feed" do
    get 'index', :format => 'atom'
    response.should be_success
    response.should render_template("_atom_feed")
    assert_feedvalidator response.body
  end

  specify "/articles.rss => an RSS 2.0 feed" do
    get 'index', :format => 'rss'
    response.should be_success
    response.should render_template("_rss20_feed")
    response.should have_tag('link', 'http://myblog.net')
    assert_feedvalidator response.body
  end

  specify "atom feed for archive should be valid" do
    get 'index', :year => 2004, :month => 4, :format => 'atom'
    response.should render_template("_atom_feed")
    assert_feedvalidator response.body
  end

  specify "RSS feed for archive should be valid" do
    get 'index', :year => 2004, :month => 4, :format => 'rss'
    response.should render_template("_rss20_feed")
    assert_feedvalidator response.body
  end

  it 'should create valid atom feed when article contains &eacute;' do
    article = contents(:article2)
    article.body = '&eacute;coute!'
    article.save!
    get 'index', :format => 'atom'
    #response.body.should =~ /écoute!/
    assert_feedvalidator response.body
  end

  it 'should create valid atom feed when article contains loose <' do
    article = contents(:article2)
    article.body = 'is 4 < 2? no!'
    article.save!
    get 'index', :format => 'atom'
    assert_feedvalidator response.body
  end
end
