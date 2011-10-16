require 'spec_helper'

describe CommentsController do
  before do
    @blog = Factory(:blog)
  end

  describe '#create' do
    describe "Basic comment creation" do
      before do
        @article = Factory(:article)
        comment = {:body => 'content', :author => 'bob', :email => 'bob@home', :url => 'http://bobs.home/'}
        post :create, :comment => comment, :article_id => @article.id
      end

      it "should assign the new comment to @comment" do
        assigns[:comment].should == Comment.find_by_author_and_body_and_article_id('bob', 'content', @article.id)
      end

      it "should assign the article to @article" do
        assigns[:article].should == @article
      end

      it "should save the comment" do
        @article.comments.size.should == 1
      end

      it "should set the author" do
        @article.comments.last.author.should == 'bob'
      end

      it "should set an author cookie" do
        cookies["author"].should == 'bob'
      end

      it "should set a gravatar_id cookie" do
        cookies["gravatar_id"].should == Digest::MD5.hexdigest('bob@home')
      end

      it "should set a url cookie" do
        cookies["url"].should == 'http://bobs.home/'
      end
    end


    it "should redirect to the article" do
      article = Factory(:article, :created_at => '2005-01-01 02:00:00')
      post :create, :comment => {:body => 'content', :author => 'bob'},
        :article_id => article.id
      response.should redirect_to("#{@blog.base_url}/#{article.created_at.year}/#{sprintf("%.2d", article.created_at.month)}/#{sprintf("%.2d", article.created_at.day)}/#{article.permalink}")
    end
  end

  describe 'AJAX creation' do
    it "should render the comment partial" do
      xhr :post, :create, :comment => {:body => 'content', :author => 'bob'},
        :article_id => Factory(:article).id
      response.should render_template("/articles/_comment")
    end
  end

  describe "#index" do
    context 'scoped index' do
      it "GET 2007/10/11/slug/comments should redirect to /2007/10/11/slug#comments" do
        article = Factory(:article, :created_at => '2005-01-01 02:00:00')
        get 'index', :article_id => article.id
        response.should redirect_to("#{@blog.base_url}/#{article.created_at.year}/#{sprintf("%.2d", article.created_at.month)}/#{sprintf("%.2d", article.created_at.day)}/#{article.permalink}#comments")
      end

    end

    context "without format" do
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

    context "with :format => 'atom'" do
      context "without article" do
        before do
          Comment.should_receive(:find).and_return(['some','items'])
          get 'index', :format => 'atom'
        end

        it "is succesful" do
          response.should be_success
        end

        it "passes the comments to the template" do
          assigns(:comments).should == ["some", "items"]
        end

        it "should return an atom feed" do
          response.should render_template("index_atom_feed")
        end
      end

      context "with an article" do
        it "should return an atom feed" do
          get :index, :format => 'atom', :article_id => Factory(:article).id
          response.should be_success
          response.should render_template("index_atom_feed")
        end
      end
    end

    context "with :format => 'rss'" do
      context "without article" do
        before do
          Comment.should_receive(:find).and_return(['some','items'])
          get 'index', :format => 'rss'
        end

        it "is succesful" do
          response.should be_success
        end

        it "passes the comments to the template" do
          assigns(:comments).should == ["some", "items"]
        end

        it "should return an rss feed" do
          response.should render_template("index_rss_feed")
        end
      end

      context "with article" do
        it "should return an rss feed" do
          get :index, :format => 'rss', :article_id => Factory(:article).id
          response.should be_success
          response.should render_template("index_rss_feed")
        end
      end
    end
  end
end
