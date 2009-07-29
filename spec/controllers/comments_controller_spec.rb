require File.dirname(__FILE__) + '/../spec_helper'

describe "All Requests", :shared => true do
  before do
    @comment  = mock_model(Comment,
                  :save                       => true,
                  :author                     => 'bob',
                  :email                      => 'bob@home',
                  :url                        => 'http://bobs.home/')
    @article  = contents(:article1)
    @blog     = blogs(:default)
  end
end

describe "General Comment Creation", :shared => true do
  it_should_behave_like "All Requests"

  it "should assign the new comment to @comment" do
    make_the_request
    assigns[:comment].should == Comment.find_by_author_and_body_and_article_id('bob', 'content', contents(:article1).id)
  end

  it "should assign the article to @article" do
    make_the_request
    assigns[:article].should == @article
  end

  it "should save the comment" do
    lambda do
      make_the_request
    end.should change(Comment, :count).by(1)
  end

  it "should set the author" do
    make_the_request
    contents(:article1).comments.last.author.should == 'bob'
  end

  it "should set an author cookie" do
    make_the_request
    cookies["author"].should == 'bob'
  end

  it "should set a gravatar_id cookie" do
    make_the_request(:body => 'content', :author => 'bob',
                     :email => 'bob@home', :url => 'http://bobs.home/')
    cookies["gravatar_id"].should == Digest::MD5.hexdigest('bob@home')
  end

  it "should set a url cookie" do
    make_the_request(:body => 'content', :author => 'bob',
                     :email => 'bob@home', :url => 'http://bobs.home/')
    cookies["url"].should == 'http://bobs.home/'
  end

  it "should create a comment" do
    make_the_request
  end

end

describe CommentsController, 'create' do
  it_should_behave_like "General Comment Creation"

  def make_the_request(comment = {:body => 'content', :author => 'bob'})
    post :create, :comment => comment, :article_id => contents(:article1).id
  end

  it "should throw an error if sp_allow_non_ajax_comments is false and there are no xhr headers" do
    b = blogs(:default)
    b.sp_allow_non_ajax_comments = false
    b.save
    make_the_request
    response.response_code.should == 400
  end

  it "should redirect to the article" do
    make_the_request
    response.should redirect_to("#{blogs(:default).base_url}/#{contents(:article1).created_at.year}/#{sprintf("%.2d", contents(:article1).created_at.month)}/#{sprintf("%.2d", contents(:article1).created_at.day)}/#{contents(:article1).permalink}")
  end
end

describe CommentsController, 'AJAX creation' do
  it_should_behave_like "General Comment Creation"

  def make_the_request(comment = {:body => 'content', :author => 'bob'})
    xhr :post, :create, :comment => comment, :article_id => contents(:article1).id
  end

  it "should be be successful if blog.sp_allow_non_ajax_comments is false" do
    b = blogs(:default)
    b.sp_allow_non_ajax_comments = false
    b.save
    b.sp_allow_non_ajax_comments.should_not be_true
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

  it "GET 2007/10/11/slug/comments should redirect to /2007/10/11/slug#comments" do
    #content(:article1) => Time.now - 2 days
    get 'index', :article_id => @article.id
    response.should redirect_to("#{blogs(:default).base_url}/#{contents(:article1).created_at.year}/#{sprintf("%.2d", contents(:article1).created_at.month)}/#{sprintf("%.2d", contents(:article1).created_at.day)}/#{contents(:article1).permalink}#comments")
  end

  it "GET /2007/10/11/slug/comments.atom should return an atom feed" do
    get :index, :format => 'atom', :article_id => contents(:article1).id
    response.should be_success
    response.should render_template("articles/_atom_feed")
  end

  it "GET /2007/10/11/slug/comments.rss should return an rss feed" do
    get :index, :format => 'rss', :article_id => contents(:article1).id
    response.should be_success
    response.should render_template("articles/_rss20_feed")
  end
end

describe CommentsController, 'GET /comments' do
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
