require File.dirname(__FILE__) + '/../spec_helper'

describe CommentsController, "routes" do
  def routes
    ActionController::Routing::Routes
  end

  def basic_result(action, method = :get)
    return { :controller => 'comments', :article_year => '2007', :article_month => '10', :article_day => '11',
      :article_id => 'slug', :action => action}
  end

  it "should recognize GET /articles/2007/10/11/slug/comments" do
    routes.recognize_path('/articles/2007/10/11/slug/comments', :method => :get).should ==
      basic_result('index')
  end
end

describe "All Requests", :shared => true do
  def do_request(method = :get, action = 'index', *args)
    with_options(:article_year => '2007', :article_month => '10',
                 :article_day => '11', :article_id => 'slug') do |requester|
      requester.send(method, action, *args)
    end
  end

  before do
    @comment  = mock_model(Comment,
                  :save                       => true,
                  :author                     => 'bob',
                  :email                      => 'bob@home',
                  :url                        => 'http://bobs.home/')
    @article  = mock_model(Article,
                  :comments                   => @comments,
                  :published_comments         => @comments,
                  :add_comment                => @comment)
    @blog     = mock_model(Blog,
                  :sp_allow_non_ajax_comments => true,
                  :lang                       => 'en_US',
                  :blog_name                  => "A Blog",
                  :theme                      => 'azure',
                  :articles                   => @articles,
                  :requested_article          => @article)

    @article.stub!(:to_param).and_return(['2007', '10', '11', 'slug'])
    Article.stub!(:find).and_return(@article)

    Comment.stub!(:find).and_return(@comment)
    Blog.stub!(:find).and_return(@blog)
#    controller.stub!(:article_path).and_return('/articles/2007/10/11/slug')
  end
end

describe "General Comment Creation", :shared => true do
  it_should_behave_like "All Requests"

  before do
    @article.stub!(:permalink_url).and_return('foo')
    @article.stub!(:add_comment).and_return(@comment)
    @comments.stub!(:build).and_return(@comment)
    @comment.stub!(:save).and_return(true)
    @comment.stub!(:author).and_return('bob')
    @comment.stub!(:email).and_return('bob@home')
    @comment.stub!(:url).and_return('http://bobs.home/')
  end

  it "should assign the new comment to @comment" do
    make_the_request
    assigns[:comment].should == @comment
  end

  it "should assign the article to @article" do
    make_the_request
    assigns[:article].should == @article
  end

  it "should save the comment" do
    @comment.should_receive(:save).and_return(true)
    make_the_request
  end

  it "should set the author" do
    @article.should_receive(:add_comment) do |opts|
      opts[:author].should == 'bob'
      @comment
    end

    make_the_request
  end

  it "should set an author cookie" do
    make_the_request
    cookies["author"].should == ['bob']
  end

  it "should set a gravatar_id cookie" do
    make_the_request(:body => 'content', :author => 'bob',
                     :email => 'bob@home', :url => 'http://bobs.home/')
    cookies["gravatar_id"].should == [Digest::MD5.hexdigest('bob@home')]
  end

  it "should set a url cookie" do
    make_the_request(:body => 'content', :author => 'bob',
                     :email => 'bob@home', :url => 'http://bobs.home/')
    cookies["url"].should == ['http://bobs.home/']
  end

  it "should create a comment" do
    @blog.should_receive(:requested_article).and_return(@article)
    @article.should_receive(:add_comment).and_return(@comment)
    @article.should_receive(:to_param).at_least(:once).and_return(['2007', '10', '11', 'slug'])

    make_the_request
  end

end

describe CommentsController, 'create' do
  it_should_behave_like "General Comment Creation"

  def make_the_request(comment = {:body => 'content', :author => 'bob'})
    do_request(:post, :create, :comment => comment)
  end

  it "should throw an error if sp_allow_non_ajax_comments is false and there are no xhr headers" do
    @blog.should_receive(:sp_allow_non_ajax_comments).and_return(false)
    make_the_request
    response.response_code.should == 400
  end

  it "should redirect to the article" do
    make_the_request
    response.should redirect_to('/articles/2007/10/11/slug')
  end
end

describe CommentsController, 'AJAX creation' do
  it_should_behave_like "General Comment Creation"

  def make_the_request(comment = {:body => 'content', :author => 'bob'})
    do_request(:xhr, :post, :create, :comment => comment)
  end

  it "should be be successful if blog.sp_allow_non_ajax_comments is false" do
    @blog.should_receive(:sp_allow_non_ajax_comments).and_return(false)
    make_the_request
    response.should be_success
  end

  it "should render the comment partial" do
    make_the_request
    response.should render_template("/articles/_comment")
  end
end

describe CommentsController, 'scoped index' do
  it_should_behave_like "All Requests"

  it "GET /articles/2007/10/11/slug/comments should redirect to /articles/2007/10/11/slug#comments" do
    do_request :get, 'index'
    response.should redirect_to("/articles/2007/10/11/slug#comments")
  end

  it "GET /articles/2007/10/11/slug/comments.atom should return an atom feed" do
    do_request :get, 'index', :format => 'atom'
    response.should be_success
    response.should render_template("articles/_atom_feed")
  end

  it "GET /articles/2007/10/11/slug/comments.rss should return an rss feed" do
    do_request :get, 'index', :format => 'rss'
    response.should be_success
    response.should render_template("articles/_rss20_feed")
  end
end

describe CommentsController, 'GET /comments' do
  before do
    @the_mock = mock('blog', :null_object => true)
    @the_mock.stub!(:lang).and_return('en_US')
    Blog.stub!(:find).and_return(@the_mock)
  end

  it "should be successful" do
    get 'index'
    response.should be_success
  end

  it "should not bother fetching any comments " do
    mock_comments = mock('comments')
    @the_mock.should_not_receive(:published_comments)
    @the_mock.should_not_receive(:rss_limit_params)

    get 'index'
  end
end

describe CommentsController, "GET /comments.:format" do
  before do
    @the_mock = mock('blog', :null_object => true)
    @the_mock.stub!(:lang).and_return('en_US')
    controller.stub!(:this_blog).and_return(@the_mock)
  end

  it ":format => 'atom' should return an atom feed" do
    get 'index', :format => 'atom'
    response.should be_success
    response.should render_template("articles/_atom_feed")
  end

  it ":format => 'rss' should return an rss feed" do
    get 'index', :format => 'rss'
    response.should be_success
    response.should render_template("articles/_rss20_feed")
  end
end
