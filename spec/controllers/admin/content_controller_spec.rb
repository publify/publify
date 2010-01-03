require File.dirname(__FILE__) + '/../../spec_helper'

require 'http_mock'

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

  describe 'autosave action', :shared => true do
    it 'should save new article with draft status and link to other article if first autosave' do
      lambda do
      lambda do
        post :autosave, :article => {:allow_comments => '1',
          :body_and_extended => 'my draft in autosave',
          :keywords => 'mientag',
          :permalink => 'big-post',
          :title => 'big post',
          :text_filter => 'none',
          :published => '1',
          :published_at => 'December 23, 2009 03:20 PM'}
      end.should change(Article, :count)
      end.should change(Tag, :count)
      result = Article.last
      result.body.should == 'my draft in autosave'
      result.title.should == 'big post'
      result.permalink.should == 'big-post'
      result.parent_id.should be_nil
    end

    describe "for a published article" do
      before :each do
        @article = contents(:article1)
        @data = {:allow_comments => @article.allow_comments,
          :body_and_extended => 'my draft in autosave',
          :keywords => '',
          :permalink => @article.permalink,
          :title => @article.title,
          :text_filter => @article.text_filter,
          :published => '1',
          :published_at => 'December 23, 2009 03:20 PM'}
      end

      it 'should create a draft article with proper attributes and existing article as a parent' do
        lambda do
          post :autosave, :id => @article.id, :article => @data
        end.should change(Article, :count)
        result = Article.last
        result.body.should == 'my draft in autosave'
        result.title.should == @article.title
        result.permalink.should == @article.permalink
        result.parent_id.should == @article.id
      end

      it 'should not create another draft article with parent_id if article has already a draft associated' do
        draft = Article.create!(@article.attributes.merge(:guid => nil, :state => 'draft', :parent_id => @article.id))
        lambda do
          post :autosave, :id => @article.id, :article => @data
        end.should_not change(Article, :count)
        Article.last.parent_id.should == @article.id
      end

      it 'should create a draft with the same permalink even if the title has changed' do
        @data[:title] = @article.title + " more stuff"
        lambda do
          post :autosave, :id => @article.id, :article => @data
        end.should change(Article, :count)
        result = Article.last
        result.parent_id.should == @article.id
        result.permalink.should == @article.permalink
      end
    end
  end

  describe 'insert_editor action' do

    before do
      @user = users(:tobi)
      request.session = { :user => @user.id }
    end

    it 'should render _simple_editor' do
      get(:insert_editor, :editor => 'simple')
      response.should render_template('_simple_editor')
    end

    it 'should render _visual_editor' do
      get(:insert_editor, :editor => 'visual')
      response.should render_template('_visual_editor')
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
        u = users(:randomuser)
        u.notify_via_email = true
        u.notify_on_new_articles = true
        u.save!
        ActionMailer::Base.perform_deliveries = true
        ActionMailer::Base.deliveries = []
        category = Factory(:category)
        emails = ActionMailer::Base.deliveries

        assert_difference 'Article.count_published_articles' do
          tags = ['foo', 'bar', 'baz bliz', 'gorp gack gar']
          post :new,
            'article' => base_article(:keywords => tags) ,
            'categories' => [category.id]
          assert_response :redirect, :action => 'show'
        end

        new_article = Article.last
        assert_equal @user, new_article.user
        assert_equal 1, new_article.categories.size
        assert_equal [category], new_article.categories
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
    it_should_behave_like 'autosave action'

    describe 'edit action' do

      it 'should edit article' do
        get :edit, 'id' => contents(:article1).id
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

      it 'should delete draft about this article if update' do
        article = contents(:article1)
        draft = Article.create!(article.attributes.merge(:state => 'draft', :parent_id => article.id, :guid => nil))
        lambda do
          post :edit, 'id' => article.id, 'article' => { 'title' => 'new'}
        end.should change(Article, :count).by(-1)
        Article.should_not be_exists({:id => draft.id})
      end

      it 'should delete all draft about this article if update not happen but why not' do
        article = contents(:article1)
        draft = Article.create!(article.attributes.merge(:state => 'draft', :parent_id => article.id, :guid => nil))
        draft_2 = Article.create!(article.attributes.merge(:state => 'draft', :parent_id => article.id, :guid => nil))
        lambda do
          post :edit, 'id' => article.id, 'article' => { 'title' => 'new'}
        end.should change(Article, :count).by(-2)
        Article.should_not be_exists({:id => draft.id})
        Article.should_not be_exists({:id => draft_2.id})
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
        assert assigns(:article).valid?
        assert assigns(:resource).valid?
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
