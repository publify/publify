require File.dirname(__FILE__) + '/../../../test/test_helper'
require File.dirname(__FILE__) + '/../../spec_helper'
require 'admin/content_controller'

require 'http_mock'

# Re-raise errors caught by the controller.
module Admin
end

class Admin::ContentController; def rescue_action(e) raise e end; end

describe Admin::ContentController do
  integrate_views


  # Like it's a shared, need call everywhere
  describe 'index action', :shared => true do

    it 'should render template index' do
      get 'index'
      response.should render_template('index')
    end

    it 'should see all published in index' do
      get :index, :search => {:published => '0', :published_at => '2008-08', :user_id => '2'}
      response.should render_template('index')
      response.should be_success
    end

    it 'should restrict only by searchstring' do
      get :index, :search => {:searchstring => 'originally'}
      assigns(:articles).should == [contents(:xmltest)]
      response.should render_template('index')
      response.should be_success
    end

    it 'should restrict by searchstring and published_at' do
      get :index, :search => {:searchstring => 'originally', :published_at => '2008-08'}
      assigns(:articles).should be_empty
      response.should render_template('index')
      response.should be_success
    end

  end

  describe 'insert_editor action' do
    
    before do
      @user = users(:tobi)
      request.session = { :user => @user.id }
    end
    
    it 'should render _simple_editor' do
      get(:insert_editor, :editor => 'simple')
      response.should render_template('simple_editor')
    end

    it 'should render _visual_editor' do
      get(:insert_editor, :editor => 'visual')
      response.should render_template('visual_editor')
    end

  end


  describe 'new action', :shared => true do

    it 'should render new with get' do
      get :new
      response.should render_template('new')
      assert_template_has 'article'
    end

    def base_article(options={})
      { :title => "posted via tests!",
        :body => "A good body",
        :keywords => "tagged",
        :allow_comments => '1', 
        :allow_pings => '1' }.merge(options)
    end

    it 'should create article with no comments' do
      post(:new, 'article' => base_article({:allow_comments => '0'}),
                 'categories' => [categories(:software).id])
      assigns(:article).should_not be_allow_comments
      assigns(:article).should be_allow_pings
      assigns(:article).should be_published
    end

    it 'should create article with no pings' do
      post(:new, 'article' => {:allow_pings => '0'},
                 'categories' => [categories(:software).id])
      assigns(:article).should be_allow_comments
      assigns(:article).should_not be_allow_pings
      assigns(:article).should be_published
    end

    it 'should create' do
      begin
        ActionMailer::Base.perform_deliveries = true
        ActionMailer::Base.deliveries = []
        num_articles = Article.count_published_articles
        emails = ActionMailer::Base.deliveries
        tags = ['foo', 'bar', 'baz bliz', 'gorp gack gar']
        post :new, 'article' => base_article(:keywords => tags) , 'categories' => [categories(:software).id]
        assert_response :redirect, :action => 'show'

        assert_equal num_articles + 1, Article.count_published_articles

        new_article = Article.find(:first, :order => "id DESC")
        assert_equal @user, new_article.user
        assert_equal 1, new_article.categories.size
        assert_equal [categories(:software)], new_article.categories
        assert_equal 4, new_article.tags.size

        assert_equal(1, emails.size)
        assert_equal('randomuser@example.com', emails.first.to[0])
      ensure
        ActionMailer::Base.perform_deliveries = false
      end
    end

    it 'should create article in future' do
      assert_no_difference 'Article.count_published_articles' do
        post(:new,
             :article =>  base_article(:published_at => Time.now + 1.hour) )
        assert_response :redirect, :action => 'show'
        assigns(:article).should_not be_published
      end
      assert_equal 1, Trigger.count
    end

    it 'should create a filtered article' do
      body = "body via *markdown*"
      extended="*foo*"
      post :new, 'article' => { :title => "another test", :body => body, :extended => extended}
      assert_response :redirect, :action => 'show'

      new_article = Article.find(:first, :order => "created_at DESC")
      assert_equal body, new_article.body
      assert_equal extended, new_article.extended
      assert_equal "markdown", new_article.text_filter.name
      assert_equal "<p>body via <em>markdown</em></p>", new_article.html(:body)
      assert_equal "<p><em>foo</em></p>", new_article.html(:extended)
    end

  end

  describe 'destroy action', :shared => true do

    it 'should_not destroy article by get' do
      assert_no_difference 'Article.count' do
        art_id = @article.id
        assert_not_nil Article.find(art_id)

        get :destroy, 'id' => art_id
        response.should be_success
      end
    end

    it 'should destroy article by post' do
      assert_difference 'Article.count', -1 do
        art_id = @article.id
        post :destroy, 'id' => art_id
        response.should redirect_to(:action => 'index')

        lambda{
          article = Article.find(art_id)
        }.should raise_error(ActiveRecord::RecordNotFound)
      end
    end

  end


  describe 'with admin connection' do

    before do
      @user = users(:tobi)
      @article = contents(:article1)
      request.session = { :user => @user.id }
    end

    it_should_behave_like 'index action'
    it_should_behave_like 'new action'
    it_should_behave_like 'destroy action'

    describe 'edit action' do

      it 'should edit article' do
        get :edit, 'id' => contents(:article1).id
        assigns(:selected).should == contents(:article1).categories.collect {|c| c.id}
        response.should render_template('new')
        assert_template_has 'article'
        assigns(:article).should be_valid
        response.should have_text(/body/)
        response.should have_text(/extended content/)
      end

      it 'should update article by edit action' do
        begin
          ActionMailer::Base.perform_deliveries = true
          emails = ActionMailer::Base.deliveries
          emails.clear

          art_id = contents(:article1).id

          body = "another *textile* test"
          post :edit, 'id' => art_id, 'article' => {:body => body, :text_filter => 'textile'}
          assert_response :redirect, :action => 'show', :id => art_id

          article = contents(:article1).reload
          article.text_filter.name.should == "textile"
          body.should == article.body

          emails.size.should == 0
        ensure
          ActionMailer::Base.perform_deliveries = false
        end
      end

      it 'should allow updating body_and_extended' do
        article = contents(:article1)
        post :edit, 'id' => article.id, 'article' => {
          'body_and_extended' => 'foo<!--more-->bar<!--more-->baz'
        }
        assert_response :redirect
        article.reload
        article.body.should == 'foo'
        article.extended.should == 'bar<!--more-->baz'
      end
    end

    describe 'resource_add action' do

      it 'should add resource' do
        art_id = contents(:article1).id
        get :resource_add, :id => art_id, :resource_id => resources(:resource1).id

        response.should render_template('_show_resources')
        assigns(:article).should be_valid
        assigns(:resource).should be_valid
        assert Article.find(art_id).resources.include?(resources(:resource1))
        assert_not_nil assigns(:article)
        assert_not_nil assigns(:resource)
        assert_not_nil assigns(:resources)
      end

    end

    describe 'resource_remove action' do

      it 'should remove resource' do
        art_id = contents(:article1).id
        get :resource_remove, :id => art_id, :resource_id => resources(:resource1).id

        response.should render_template('_show_resources')
        assert_valid assigns(:article)
        assert_valid assigns(:resource)
        assert !Article.find(art_id).resources.include?(resources(:resource1))
        assert_not_nil assigns(:article)
        assert_not_nil assigns(:resource)
        assert_not_nil assigns(:resources)
      end
    end

    describe 'auto_complete_for_article_keywords action' do
      it 'should return foo for keywords fo' do
        get :auto_complete_for_article_keywords, :article => {:keywords => 'fo'}
        response.should be_success
        response.body.should == '<ul><li>foo</li></ul>'
      end

      it 'should return nothing for hello' do
        get :auto_complete_for_article_keywords, :article => {:keywords => 'hello'}
        response.should be_success
        response.body.should == '<ul></ul>'
      end

      it 'should return bar and baz for ba keyword' do
        get :auto_complete_for_article_keywords, :article => {:keywords => 'ba'}
        response.should be_success
        response.body.should == '<ul><li>bar</li><li>bazz</li></ul>'
      end
    end

  end

  describe 'with publisher connection' do

    before :each do
      @user = users(:user_publisher)
      @article = contents(:publisher_article)
      request.session = {:user => @user.id}
    end

    it_should_behave_like 'index action'
    it_should_behave_like 'new action'
    it_should_behave_like 'destroy action'

    describe 'edit action' do

      it "should redirect if edit article doesn't his" do
        get :edit, :id => contents(:article1).id
        response.should redirect_to(:action => 'index')
      end

      it 'should edit article' do
        get :edit, 'id' => contents(:publisher_article).id
        assigns(:selected).should == contents(:publisher_article).categories.collect {|c| c.id}
        response.should render_template('new')
        assert_template_has 'article'
        assigns(:article).should be_valid
      end

      it 'should update article by edit action' do
        begin
          ActionMailer::Base.perform_deliveries = true
          emails = ActionMailer::Base.deliveries
          emails.clear

          art_id = contents(:publisher_article).id

          body = "another *textile* test"
          post :edit, 'id' => art_id, 'article' => {:body => body, :text_filter => 'textile'}
          response.should redirect_to(:action => 'index')

          article = contents(:publisher_article).reload
          article.text_filter.name.should == "textile"
          body.should == article.body

          emails.size.should == 0
        ensure
          ActionMailer::Base.perform_deliveries = false
        end
      end
    end

    describe 'destroy action can be access' do

      it 'should redirect when want destroy article' do
        assert_no_difference 'Article.count' do
          get :destroy, :id => contents(:article1)
          response.should redirect_to(:action => 'index')
        end
      end

      it 'should redirect when want destroy article' do
        assert_no_difference 'Article.count' do
          post :destroy, :id => contents(:article1)
          response.should redirect_to(:action => 'index')
        end
      end

    end

  end

end
