require 'spec_helper'

shared_examples_for "General Comment Creation" do
  it "should assign the new comment to @comment" do
    article = Factory(:article)
    post :create, :comment => {:body => 'content', :author => 'bob'},
      :article_id => article.id
    assigns[:comment].should == Comment.find_by_author_and_body_and_article_id('bob', 'content', article.id)
  end

  it "should assign the article to @article" do
    article = Factory(:article)
    post :create, :comment => {:body => 'content', :author => 'bob'},
      :article_id => article.id
    assigns[:article].should == article
  end

  it "should save the comment" do
    lambda do
      post :create, :comment => {:body => 'content', :author => 'bob'},
        :article_id => Factory(:article).id
    end.should change(Comment, :count).by(1)
  end

  it "should set the author" do
    article = Factory(:article)
    post :create, :comment => {:body => 'content', :author => 'bob'},
      :article_id => article.id
    article.comments.last.author.should == 'bob'
  end

  it "should set an author cookie" do
    post :create, :comment => {:body => 'content', :author => 'bob'},
      :article_id => Factory(:article).id
    cookies["author"].should == 'bob'
  end

  it "should set a gravatar_id cookie" do
      post :create, :comment => {:body => 'content', :author => 'bob',
        :email => 'bob@home', :url => 'http://bobs.home/'},
        :article_id => Factory(:article).id
    cookies["gravatar_id"].should == Digest::MD5.hexdigest('bob@home')
  end

  it "should set a url cookie" do
    post :create, :comment => {:body => 'content', :author => 'bob',
     :email => 'bob@home', :url => 'http://bobs.home/'},
     :article_id => Factory(:article).id
    cookies["url"].should == 'http://bobs.home/'
  end

  it "should create a comment" do
    post :create, :comment => {:body => 'content', :author => 'bob'},
      :article_id => Factory(:article).id
  end
end

describe CommentsController do
  before do
    @blog = Factory(:blog, :sp_global => false)
  end

  describe 'create' do
    it_should_behave_like "General Comment Creation"

    it "should redirect to the article" do
      article = Factory(:article, :created_at => '2005-01-01 02:00:00')
      post :create, :comment => {:body => 'content', :author => 'bob'},
        :article_id => article.id
      response.should redirect_to("#{@blog.base_url}/#{article.created_at.year}/#{sprintf("%.2d", article.created_at.month)}/#{sprintf("%.2d", article.created_at.day)}/#{article.permalink}")
    end
  end

  describe 'AJAX creation' do
    it_should_behave_like "General Comment Creation"

    it "should render the comment partial" do
      xhr :post, :create, :comment => {:body => 'content', :author => 'bob'},
        :article_id => Factory(:article).id
      response.should render_template("/articles/_comment")
    end
  end

  describe 'scoped index' do
    it "GET 2007/10/11/slug/comments should redirect to /2007/10/11/slug#comments" do
      article = Factory(:article, :created_at => '2005-01-01 02:00:00')
      get 'index', :article_id => article.id
      response.should redirect_to("#{@blog.base_url}/#{article.created_at.year}/#{sprintf("%.2d", article.created_at.month)}/#{sprintf("%.2d", article.created_at.day)}/#{article.permalink}#comments")
    end

    it "GET /2007/10/11/slug/comments.atom should return an atom feed" do
      get :index, :format => 'atom', :article_id => Factory(:article).id
      response.should be_success
      response.should render_template("articles/_atom_feed")
    end

    it "GET /2007/10/11/slug/comments.rss should return an rss feed" do
      get :index, :format => 'rss', :article_id => Factory(:article).id
      response.should be_success
      response.should render_template("articles/_rss20_feed")
    end
  end
end

describe CommentsController, 'GET /comments' do
  before(:each) { Factory(:blog) }

  it "should be successful" do
    get 'index'
    response.should be_success
  end

  it "should not bother fetching any comments " do
    mock_comment = mock(Comment)
    mock_comment.should_not_receive(:published_comments)
    mock_comment.should_not_receive(:rss_limit_params)

    get 'index'
  end
end

describe CommentsController, "GET /comments.:format" do
  before(:each) { Factory(:blog) }

  it ":format => 'atom' should return an atom feed" do
    get 'index', :format => 'atom'
    response.should be_success
    response.should render_template("articles/_atom_feed")
  end

  it ":format => 'rss' should return an rss feed"do
    get 'index', :format => 'rss'
    response.should be_success
    response.should render_template("articles/_rss20_feed")
  end
end
