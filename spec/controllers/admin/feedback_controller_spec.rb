require File.dirname(__FILE__) + '/../../../test/test_helper'
require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::FeedbackController do

  integrate_views

  before do
    request.session = { :user => users(:tobi).id }
  end

  describe 'index action' do

    def should_success_with_index(response)
      response.should be_success
      response.should render_template('index')
    end

    it 'should success' do
      get :index
      should_success_with_index(response)
      #FIXME : Test is useless because the pagination is on 10. Now there are 11
      #feedback, so there are several feedback :(
      assert_equal 10, assigns(:feedback).size #Feedback.count, assigns(:feedback).size
    end

    it 'should view only confirmed feedback' do
      get :index, :confirmed => 'f'
      should_success_with_index(response)
      Feedback.count(:conditions => { :status_confirmed => false }).should == assigns(:feedback).size
    end

    it 'should view only spam feedback' do
      get :index, :published => 'f'
      should_success_with_index(response)
      Feedback.count(:conditions => { :published => false }).should == assigns(:feedback).size
    end

    it 'should view unconfirmed_spam' do
      get :index, :published => 'f', :confirmed => 'f'
      should_success_with_index(response)
      Feedback.count(:conditions => { :published => false, :status_confirmed => false }).should == assigns(:feedback).size
    end

    it 'should get page 1 if page params empty' do
      get :index, :page => ''
      should_success_with_index(response)
    end

  end

  describe 'article action' do

    def should_success_with_article_view(response)
      response.should be_success
      response.should render_template('article')
    end

    it 'should see all feedback on one article' do
      get :article, :id => contents(:article1).id
      should_success_with_article_view(response)
      assigns(:article).should == contents(:article1)
      assigns(:comments).size.should == 2
    end

    it 'should see only spam feedback on one article' do
      get :article, :id => contents(:article1).id, :spam => 'y'
      should_success_with_article_view(response)
      assigns(:article).should == contents(:article1)
      assigns(:comments).size.should == 1
    end

    it 'should see only ham feedback on one article' do
      get :article, :id => contents(:article1).id, :ham => 'y'
      should_success_with_article_view(response)
      assigns(:article).should == contents(:article1)
      assigns(:comments).size.should == 1
    end

    it 'should redirect_to index if bad article id' do
      lambda{
        get :article, :id => 102302
      }.should raise_error(ActiveRecord::RecordNotFound)
    end

  end

  describe 'create action' do

    def base_comment(options = {})
      {"body"=>"a new comment", "author"=>"Me", "url"=>"http://typosphere.org", "email"=>"dev@typosphere.org"}.merge(options)
    end

    describe 'by get access' do
      it "should raise ActiveRecordNotFound if article doesn't exist" do
        lambda {
          get 'create', :article_id => 120431, :comment => base_comment
        }.should raise_error(ActiveRecord::RecordNotFound)
      end

      it 'should not create comment' do
        assert_no_difference 'Comment.count' do
          get 'create', :article_id => contents(:article1).id, :comment => base_comment
          response.should redirect_to(:action => 'article', :id => contents(:article1).id)
        end
      end

    end

    describe 'by post access' do
      it "should raise ActiveRecordNotFound if article doesn't exist" do
        lambda {
          post 'create', :article_id => 123104, :comment => base_comment
        }.should raise_error(ActiveRecord::RecordNotFound)
      end

      it 'should create comment' do
        assert_difference 'Comment.count' do
          post 'create', :article_id => contents(:article1).id, :comment => base_comment
          response.should redirect_to(:action => 'article', :id => contents(:article1).id)
        end
      end

      it 'should create comment mark as ham' do
        assert_difference 'Comment.count(:conditions => {:state => "ham"})' do
          post 'create', :article_id => contents(:article1).id, :comment => base_comment
          response.should redirect_to(:action => 'article', :id => contents(:article1).id)
        end
      end

    end

  end

  describe 'edit action' do

    it 'should render edit form' do
      get 'edit', :id => feedback(:comment2).id
      assigns(:comment).should == feedback(:comment2)
      assigns(:article).should == contents(:article1)
      response.should be_success
      response.should render_template('edit')
    end

  end

  describe 'publisher access' do

    before :each do
      request.session = { :user => users(:user_publisher).id }
    end

    describe 'edit action' do

      it 'should not edit comment no own article' do
        get 'edit', :id => feedback(:comment2).id
        response.should redirect_to(:action => 'index')
      end

      it 'should edit comment if own article' do
        get 'edit', :id => feedback(:comment_on_publisher_article).id
        response.should be_success
        response.should render_template('edit')
        assigns(:comment).should == feedback(:comment_on_publisher_article)
        assigns(:article).should == contents(:publisher_article)
      end

    end

  end

end
