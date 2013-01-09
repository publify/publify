require 'spec_helper'

describe Admin::FeedbackController do

  render_views

  shared_examples_for "destroy feedback with feedback from own article" do
    it 'should destroy feedback' do
      id = feedback_from_own_article.id
      lambda do
        post 'destroy', :id => id
      end.should change(Feedback, :count)
      lambda do
        Feedback.find(feedback_from_own_article.id)
      end.should raise_error(ActiveRecord::RecordNotFound)
    end

    it 'should redirect to feedback from article' do
      post 'destroy', :id => feedback_from_own_article.id
      response.should redirect_to(:controller => 'admin/feedback', :action => 'article', :id => feedback_from_own_article.article.id)
    end

    it 'should not destroy feedback in get request' do
      id = feedback_from_own_article.id
      lambda do
        get 'destroy', :id => id
      end.should_not change(Feedback, :count)
      lambda do
        Feedback.find(feedback_from_own_article.id)
      end.should_not raise_error(ActiveRecord::RecordNotFound)
      response.should render_template 'destroy'
    end
  end

  describe 'logged in admin user' do

    before :each do
      FactoryGirl.create(:blog)
      #TODO Delete after removing fixtures
      Profile.delete_all
      @admin = FactoryGirl.create(:user, :login => 'henri', :profile => FactoryGirl.create(:profile_admin, :label => Profile::ADMIN))
      request.session = { :user => @admin.id }
    end

    def feedback_from_own_article
      @article ||= FactoryGirl.create(:article, :user => @admin)
      @comment_own ||= FactoryGirl.create(:comment, :article => @article)
    end

    def feedback_from_not_own_article
      @spam_comment_not_own ||= FactoryGirl.create(:spam_comment)
    end

    describe 'destroy action' do

      it_should_behave_like "destroy feedback with feedback from own article"

      it "should destroy feedback from article doesn't own" do
        id = feedback_from_not_own_article.id
        lambda do
          post 'destroy', :id => id
        end.should change(Feedback, :count)
        lambda do
          Feedback.find(feedback_from_not_own_article.id)
        end.should raise_error(ActiveRecord::RecordNotFound)
        response.should redirect_to(:controller => 'admin/feedback', :action => 'article', :id => feedback_from_not_own_article.article.id)
      end
    end

    describe 'index action' do

      before(:each) do
        #Remove feedback due to some fixtures
        Feedback.delete_all
      end

      def should_success_with_index(response)
        response.should be_success
        response.should render_template('index')
      end

      it 'should success' do
        a = FactoryGirl.create(:article)
        3.times { FactoryGirl.create(:comment, :article => a) }
        get :index
        should_success_with_index(response)
        assert_equal 3, assigns(:feedback).size
      end

      it 'should view only unconfirmed feedback' do
        c = FactoryGirl.create(:comment, :state => 'presumed_ham')
        FactoryGirl.create(:comment)
        get :index, :confirmed => 'f'
        should_success_with_index(response)
        assigns(:feedback).should == [c]
      end

      it 'should view only spam feedback' do
        FactoryGirl.create(:comment)
        c = FactoryGirl.create(:spam_comment)
        get :index, :published => 'f'
        should_success_with_index(response)
        assigns(:feedback).should == [c]
      end

      it 'should view unconfirmed_spam' do
        FactoryGirl.create(:comment)
        FactoryGirl.create(:spam_comment)
        c = FactoryGirl.create(:spam_comment, :state => 'presumed_spam')
        get :index, :published => 'f', :confirmed => 'f'
        should_success_with_index(response)
        assigns(:feedback).should == [c]
      end

      # TODO: Functionality is counter-intuitive: param presumed_spam is
      # set to f(alse), but shows presumed_spam.
      it 'should view presumed_spam' do
        c = FactoryGirl.create(:comment, :state => :presumed_spam)
        FactoryGirl.create(:comment, :state => :presumed_ham)
        get :index, :presumed_spam => 'f'
        should_success_with_index(response)
        assigns(:feedback).should == [c]
      end

      it 'should view presumed_ham' do
        FactoryGirl.create(:comment)
        FactoryGirl.create(:comment, :state => :presumed_spam)
        c = FactoryGirl.create(:comment, :state => :presumed_ham)
        get :index, :presumed_ham => 'f'
        should_success_with_index(response)
        assigns(:feedback).should == [c]
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
        article = FactoryGirl.create(:article)
        FactoryGirl.create(:comment, :article => article)
        FactoryGirl.create(:comment, :article => article)
        get :article, :id => article.id
        should_success_with_article_view(response)
        assigns(:article).should == article
        assigns(:feedback).size.should == 2
      end

      it 'should see only spam feedback on one article' do
        article = FactoryGirl.create(:article)
        FactoryGirl.create(:comment, :state => 'spam', :article => article)
        get :article, :id => article.id, :spam => 'y'
        should_success_with_article_view(response)
        assigns(:article).should == article
        assigns(:feedback).size.should == 1
      end

      it 'should see only ham feedback on one article' do
        article = FactoryGirl.create(:article)
        comment = FactoryGirl.create(:comment, :article => article)
        get :article, :id => article.id, :ham => 'y'
        should_success_with_article_view(response)
        assigns(:article).should == article
        assigns(:feedback).size.should == 1
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
          article = FactoryGirl.create(:article)
          lambda do
            get 'create', :article_id => article.id, :comment => base_comment
            response.should redirect_to(:action => 'article', :id => article.id)
          end.should_not change(Comment, :count)
        end

      end

      describe 'by post access' do
        it "should raise ActiveRecord::RecordNotFound if article doesn't exist" do
          lambda {
            post 'create', :article_id => 123104, :comment => base_comment
          }.should raise_error(ActiveRecord::RecordNotFound)
        end

        it 'should create comment' do
          article = FactoryGirl.create(:article)
          lambda do
            post 'create', :article_id => article.id, :comment => base_comment
            response.should redirect_to(:action => 'article', :id => article.id)
          end.should change(Comment, :count)
        end

        it 'should create comment mark as ham' do
          article = FactoryGirl.create(:article)
          lambda do
            post 'create', :article_id => article.id, :comment => base_comment
            response.should redirect_to(:action => 'article', :id => article.id)
          end.should change { Comment.count(:conditions => {:state => "ham"}) }
        end

      end

    end

    describe 'edit action' do
      it 'should render edit form' do
        article = FactoryGirl.create(:article)
        comment = FactoryGirl.create(:comment, :article => article)
        get 'edit', :id => comment.id
        assigns(:comment).should == comment
        assigns(:article).should == article
        response.should be_success
        response.should render_template('edit')
      end
    end

    describe 'update action' do

      it 'should update comment if post request' do
        article = FactoryGirl.create(:article)
        comment = FactoryGirl.create(:comment, :article => article)
        post 'update', :id => comment.id,
          :comment => {:author => 'Bob Foo2',
            :url => 'http://fakeurl.com',
            :body => 'updated comment'}
        response.should redirect_to(:action => 'article', :id => article.id)
        comment.reload
        comment.body.should == 'updated comment'
      end

      it 'should not  update comment if get request' do
        comment = FactoryGirl.create(:comment)
        get 'update', :id => comment.id,
          :comment => {:author => 'Bob Foo2',
            :url => 'http://fakeurl.com',
            :body => 'updated comment'}
        response.should redirect_to(:action => 'edit', :id => comment.id)
        comment.reload
        comment.body.should_not == 'updated comment'
      end


    end
  end

  describe 'publisher access' do

    before :each do
      FactoryGirl.create(:blog)
      #TODO remove this delete_all after removing all fixture
      Profile.delete_all
      @publisher = FactoryGirl.create(:user, :profile => FactoryGirl.create(:profile_publisher))
      request.session = { :user => @publisher.id }
    end

    def feedback_from_own_article
      @article ||= FactoryGirl.create(:article, :user => @publisher)
      @feedback_own_article ||= FactoryGirl.create(:comment, :article => @article)
    end

    def feedback_from_not_own_article
      @article ||= FactoryGirl.create(:article, :user => FactoryGirl.create(:user, :login => 'other_user'))
      @feedback_not_own_article ||= FactoryGirl.create(:comment, :article => @article)
    end

    describe 'destroy action' do
      it_should_behave_like "destroy feedback with feedback from own article"

      it "should not destroy feedback doesn't own" do
        id = feedback_from_not_own_article.id
        post 'destroy', :id => id
        response.should redirect_to(:controller => 'admin/feedback', :action => 'index')
        lambda do
          Feedback.find(id)
        end.should_not raise_error(ActiveRecord::RecordNotFound)
      end
    end

    describe 'edit action' do

      it 'should not edit comment no own article' do
        get 'edit', :id => feedback_from_not_own_article.id
        response.should redirect_to(:action => 'index')
      end

      it 'should edit comment if own article' do
        get 'edit', :id => feedback_from_own_article.id
        response.should be_success
        response.should render_template('edit')
        assigns(:comment).should == feedback_from_own_article
        assigns(:article).should == feedback_from_own_article.article
      end

    end

    describe 'update action' do

      it 'should update comment if own article' do
        post 'update', :id => feedback_from_own_article.id,
          :comment => {:author => 'Bob Foo2',
            :url => 'http://fakeurl.com',
            :body => 'updated comment'}
        response.should redirect_to(:action => 'article', :id => feedback_from_own_article.article.id)
        feedback_from_own_article.reload
        feedback_from_own_article.body.should == 'updated comment'
      end

      it 'should not update comment if not own article' do
        post 'update', :id => feedback_from_not_own_article.id,
          :comment => {:author => 'Bob Foo2',
            :url => 'http://fakeurl.com',
            :body => 'updated comment'}
        response.should redirect_to(:action => 'index')
        feedback_from_not_own_article.reload
        feedback_from_not_own_article.body.should_not == 'updated comment'
      end
    end

    describe '#bulkops action' do
      it "redirect to index" do
        post :bulkops, bulkop_top: 'destroy all spam'
        @response.should redirect_to(action: 'index')
      end

      it "mark comments as spam" do
        comment = FactoryGirl.create(:comment, state: :presumed_spam)
        post :bulkops, bulkop_top: 'Mark Checked Items as Spam', feedback_check: {comment.id.to_s => "on"}
        comment.reload.should be_spam
      end
    end
  end
end
