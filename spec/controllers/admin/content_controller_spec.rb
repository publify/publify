 require 'spec_helper'

describe Admin::ContentController do
  render_views
  let!(:blog) { create(:blog) }

  # Like it's a shared, need call everywhere
  shared_examples_for 'index action' do

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
      article = create(:article, body: 'once uppon an originally time')
      get :index, search: {searchstring: 'originally'}
      assigns(:articles).should == [article]
      response.should render_template('index')
      response.should be_success
    end

    it 'should restrict by searchstring and published_at' do
      create(:article)
      get :index, :search => {:searchstring => 'originally', :published_at => '2008-08'}
      assigns(:articles).should be_empty
      response.should render_template('index')
      response.should be_success
    end

    it 'should restrict to drafts' do
      article = create(:article, :state => 'draft')
      get :index, :search => {:state => 'drafts'}
      assigns(:articles).should == [article]
      response.should render_template('index')
      response.should be_success
    end

    it 'should restrict to publication pending articles' do
      article = create(:article, :state => 'publication_pending', :published_at => '2020-01-01')
      get :index, :search => {:state => 'pending'}
      assigns(:articles).should == [article]
      response.should render_template('index')
      response.should be_success
    end

    it 'should restrict to withdrawn articles' do
      article = create(:article, :state => 'withdrawn', :published_at => '2010-01-01')
      get :index, :search => {:state => 'withdrawn'}
      assigns(:articles).should == [article]
      response.should render_template('index')
      response.should be_success
    end

    it 'should restrict to withdrawn articles' do
      article = create(:article, :state => 'withdrawn', :published_at => '2010-01-01')
      get :index, :search => {:state => 'withdrawn'}
      assigns(:articles).should == [article]
      response.should render_template('index')
      response.should be_success
    end

    it 'should restrict to published articles' do
      article = create(:article, :state => 'published', :published_at => '2010-01-01')
      get :index, :search => {:state => 'published'}
      response.should render_template('index')
      response.should be_success
    end

    it 'should fallback to default behavior' do
      article = create(:article, :state => 'draft')
      get :index, :search => {:state => '3vI1 1337 h4x0r'}
      response.should render_template('index')
      assigns(:articles).should_not == [article]
      response.should be_success
    end

  end

  shared_examples_for 'autosave action' do
    describe "first time for a new article" do
      it 'should save new article with draft status and no parent article' do
        create(:none)
        lambda do
        lambda do
          xhr :post, :autosave, :article => {:allow_comments => '1',
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
        result.redirects.count.should == 0
      end
    end

    describe "second time for a new article" do
      it 'should save the same article with draft status and no parent article' do
        draft = create(:article, published: false, state: 'draft')
        lambda do
          xhr :post, :autosave, :article => {
            :id => draft.id,
            :body_and_extended => 'new body' }
        end.should_not change(Article, :count)
        result = Article.find(draft.id)
        result.body.should == 'new body'
        result.parent_id.should be_nil
        result.redirects.count.should == 0
      end
    end

    describe "for a published article" do
      let(:article) { create(:article) }

      before(:each) do
        data = {:allow_comments => article.allow_comments,
          :body_and_extended => 'my draft in autosave',
          :keywords => '',
          :permalink => article.permalink,
          :title => article.title,
          :text_filter => article.text_filter,
          :published => '1',
          :published_at => 'December 23, 2009 03:20 PM'}

        xhr :post, :autosave, id: article.id, article: data
      end

      it { expect(response).to be_success }
      # TODO More pertinent tests needed
    end

    describe "with an unrelated draft in the database" do
      before do
        @draft = create(:article, :state => 'draft')
      end

      it "leaves the original draft in existence" do
        xhr :post, :autosave, article: {}
        assigns(:article).id.should_not == @draft.id
        Article.find(@draft.id).should_not be_nil
      end
    end
  end

  shared_examples_for 'new action' do
    it "renders the 'new' template" do
      get :new
      response.should render_template('new')
      assigns(:article).should_not be_nil
      assigns(:article).redirects.count.should == 0
    end
  end

  shared_examples_for 'create action' do
    def base_article(options={})
      { :title => "posted via tests!",
        :body => "A good body",
        :allow_comments => '1',
        :allow_pings => '1' }.merge(options)
    end

    it 'should create article with no comments' do
      post(:create,
           'article' => base_article({:allow_comments => '0'}),
           'tags' => [create(:tag).id])
      assigns(:article).should_not be_allow_comments
      assigns(:article).should be_allow_pings
      assigns(:article).should be_published
    end

    it 'should create a published article with a redirect' do
      post(:create, 'article' => base_article)
      assigns(:article).redirects.count.should == 1
    end

    it 'should create a draft article without a redirect' do
      post(:create, 'article' => base_article({:state => 'draft'}))
      assigns(:article).redirects.count.should == 0
    end

    it 'should create an unpublished article without a redirect' do
      post(:create, 'article' => base_article({:published => false}))
      assigns(:article).redirects.count.should == 0
    end

    it 'should create an article published in the future without a redirect' do
      post(:create, 'article' => base_article({:published_at => (Time.now + 1.hour).to_s}))
      assigns(:article).redirects.count.should == 0
    end

    it 'should create article with no pings' do
      post(:create, 'article' => {:allow_pings => '0', 'title' => 'my Title'}, 'tags' => [create(:tag).id])
      assigns(:article).should be_allow_comments
      assigns(:article).should_not be_allow_pings
      assigns(:article).should be_published
    end

    it 'should create an article linked to the current user' do
      post :create, article: base_article
      new_article = Article.last
      assert_equal @user, new_article.user
    end

    it 'should create new published article' do
      Article.count.should be == 1
      post :create, 'article' => base_article
      Article.count.should be == 2
    end

    it 'should redirect to show' do
      post :create, 'article' => base_article
      assert_response :redirect, :action => 'show'
    end

    it 'should send notifications on create' do
      begin
        u = create(:user, :notify_via_email => true, :notify_on_new_articles => true)
        u.save!
        ActionMailer::Base.perform_deliveries = true
        ActionMailer::Base.deliveries.clear
        emails = ActionMailer::Base.deliveries

        post :create, 'article' => base_article

        assert_equal(1, emails.size)
        assert_equal(u.email, emails.first.to[0])
      ensure
        ActionMailer::Base.perform_deliveries = false
      end
    end

    it 'should create an article with tags' do
      post :create, 'article' => base_article(:keywords => "foo bar")
      new_article = Article.last
      assert_equal 2, new_article.tags.size
    end

    it 'should create article in future' do
      lambda do
        post(:create,
             :article =>  base_article(:published_at => (Time.now + 1.hour).to_s) )
        assert_response :redirect, :action => 'show'
        assigns(:article).should_not be_published
      end.should_not change(Article.published, :count)
      assert_equal 1, Trigger.count
      assigns(:article).redirects.count.should == 0
    end

    it "should correctly interpret time zone in :published_at" do
      post :create, 'article' => base_article(:published_at => "February 17, 2011 08:47 PM GMT+0100 (CET)")
      new_article = Article.last
      assert_equal Time.utc(2011, 2, 17, 19, 47), new_article.published_at
    end

    it 'should respect "GMT+0000 (UTC)" in :published_at' do
      post :create, 'article' => base_article(:published_at => 'August 23, 2011 08:40 PM GMT+0000 (UTC)')
      new_article = Article.last
      assert_equal Time.utc(2011, 8, 23, 20, 40), new_article.published_at
    end

    it 'should create a filtered article' do
      Article.delete_all
      body = "body via *markdown*"
      extended="*foo*"
      post :create, 'article' => { :title => "another test", :body => body, :extended => extended}

      assert_response :redirect, :action => 'index'

      new_article = Article.find(:first, :order => "created_at DESC")

      new_article.body.should eq body
      new_article.extended.should eq extended
      new_article.text_filter.name.should eq @user.text_filter.name
      new_article.html(:body).should eq "<p>body via <em>markdown</em></p>"
      new_article.html(:extended).should eq "<p><em>foo</em></p>"
    end

    context "with a previously autosaved draft" do
      before do
        @draft = create(:article, body: 'draft', state: 'draft', published: false)
        post(:create, article: {id: @draft.id, body: 'update', published: true})
      end

      it "updates the draft" do
        Article.find(@draft.id).body.should eq 'update'
      end

      it "makes the draft published" do
        Article.find(@draft.id).should be_published
      end
    end

    describe "with an unrelated draft in the database" do
      before do
        @draft = create(:article, :state => 'draft')
      end

      describe "saving new article as draft" do
        it "leaves the original draft in existence" do
          post :create, article: base_article({:draft => 'save as draft'})
          assigns(:article).id.should_not == @draft.id
          Article.find(@draft.id).should_not be_nil
        end
      end
    end
  end

  describe 'with admin connection' do
    before(:each) do
      @user = create(:user_admin, text_filter: create(:markdown))
      @article = create(:article)
      request.session = { :user => @user.id }
    end

    it_should_behave_like 'index action'
    it_should_behave_like 'new action'
    it_should_behave_like 'create action'
    it_should_behave_like 'autosave action'

    describe 'edit action' do
      it 'should edit article' do
        get :edit, 'id' => @article.id
        response.should render_template 'edit'
        assigns(:article).should_not be_nil
        assigns(:article).should be_valid
        response.should contain(/body/)
        response.should contain(/extended content/)
      end

      it "correctly converts multi-word tags" do
        a = create(:article, :keywords => '"foo bar", baz')
        get :edit, :id => a.id
        response.should have_selector("input[id=article_keywords][value='baz, \"foo bar\"']")
      end
    end

    describe 'update action' do
      it 'should update article' do
        begin
          ActionMailer::Base.perform_deliveries = true
          emails = ActionMailer::Base.deliveries
          emails.clear

          art_id = @article.id

          body = "another *textile* test"
          put :update, 'id' => art_id, 'article' => {:body => body, :text_filter => 'textile'}
          assert_response :redirect, :action => 'show', :id => art_id

          article = @article.reload
          article.text_filter.name.should == "textile"
          body.should == article.body

          emails.size.should == 0
        ensure
          ActionMailer::Base.perform_deliveries = false
        end
      end

      it 'should allow updating body_and_extended' do
        article = @article
        put :update, 'id' => article.id, 'article' => {
          'body_and_extended' => 'foo<!--more-->bar<!--more-->baz'
        }
        assert_response :redirect
        article.reload
        article.body.should == 'foo'
        article.extended.should == 'bar<!--more-->baz'
      end

      it 'should delete draft about this article if update' do
        article = @article
        draft = Article.create!(article.attributes.merge(:state => 'draft', :parent_id => article.id, :guid => nil))
        lambda do
          put :update, 'id' => article.id, 'article' => { 'title' => 'new'}
        end.should change(Article, :count).by(-1)
        Article.should_not be_exists({:id => draft.id})
      end

      it 'should delete all draft about this article if update not happen but why not' do
        article = @article
        draft = Article.create!(article.attributes.merge(:state => 'draft', :parent_id => article.id, :guid => nil))
        draft_2 = Article.create!(article.attributes.merge(:state => 'draft', :parent_id => article.id, :guid => nil))
        lambda do
          put :update, 'id' => article.id, 'article' => { 'title' => 'new'}
        end.should change(Article, :count).by(-2)
        Article.should_not be_exists({:id => draft.id})
        Article.should_not be_exists({:id => draft_2.id})
      end

      describe "publishing a published article with an autosaved draft" do
        before do
          @orig = create(:article)
          @draft = create(:article, :parent_id => @orig.id, :state => 'draft', :published => false)
          put(:update,
              :id => @orig.id,
              :article => {:id => @draft.id, :body => 'update'})
        end

        it "updates the original" do
          Article.find(@orig.id).body.should == 'update'
        end

        it "deletes the draft" do
          assert_raises ActiveRecord::RecordNotFound do
            Article.find(@draft.id)
          end
        end
      end

      describe "publishing a draft copy of a published article" do
        before do
          @orig = create(:article)
          @draft = create(:article, :parent_id => @orig.id, :state => 'draft', :published => false)
          put(:update,
              :id => @draft.id,
              :article => {:id => @draft.id, :body => 'update'})
        end

        it "updates the original" do
          Article.find(@orig.id).body.should == 'update'
        end

        it "deletes the draft" do
          assert_raises ActiveRecord::RecordNotFound do
            Article.find(@draft.id)
          end
        end
      end

      describe "saving a published article as draft" do
        before do
          @orig = create(:article)
          put(:update,
              :id => @orig.id,
              :article => {:title => @orig.title, :draft => 'draft',
                           :body => 'update' })
        end

        it "leaves the original published" do
          @orig.reload
          @orig.published.should == true
        end

        it "leaves the original as is" do
          @orig.reload
          @orig.body.should_not == 'update'
        end

        it "redirects to the index" do
          response.should redirect_to(:action => 'index')
        end

        it "creates a draft" do
          draft = Article.child_of(@orig.id).first
          draft.parent_id.should == @orig.id
          draft.should_not be_published
        end
      end
    end

    describe 'auto_complete_for_article_keywords action' do
      before do
        create(:tag, :name => 'foo', :articles => [create(:article)])
        create(:tag, :name => 'bazz', :articles => [create(:article)])
        create(:tag, :name => 'bar', :articles => [create(:article)])
      end

      it 'should return foo for keywords fo' do
        get :auto_complete_for_article_keywords, :article => {:keywords => 'fo'}
        response.should be_success
        response.body.should == '<ul class="unstyled" id="autocomplete"><li>foo</li></ul>'
      end

      it 'should return nothing for hello' do
        get :auto_complete_for_article_keywords, :article => {:keywords => 'hello'}
        response.should be_success
        response.body.should == '<ul class="unstyled" id="autocomplete"></ul>'
      end

      it 'should return bar and bazz for ba keyword' do
        get :auto_complete_for_article_keywords, :article => {:keywords => 'ba'}
        response.should be_success
        response.body.should == '<ul class="unstyled" id="autocomplete"><li>bar</li><li>bazz</li></ul>'
      end
    end
  end

  describe 'common behavior with publisher connection' do
    let!(:user) { create(:user, text_filter: create(:markdown), profile: create(:profile_publisher)) }

    before :each do
      user.save
      @user = user
      @article = create(:article, user: user)
      request.session = {user: user.id}
    end

    it_should_behave_like 'index action'
    it_should_behave_like 'new action'
    it_should_behave_like 'create action'
  end

  describe 'with publisher connection' do
    let!(:user) { create(:user, text_filter: create(:markdown), profile: create(:profile_publisher)) }

    before(:each) { request.session = {user: user.id} }

    describe :edit do
      context "with an article from an other user" do
        let!(:article) { create(:article, user: create(:user, login: 'another_user')) }

        before(:each) { get :edit, id: article.id }
        it { expect(response).to redirect_to(action: 'index') }
      end

      context "with an article from current user" do
        let!(:article) { create(:article, user: user) }

        before(:each) { get :edit, id: article.id }
        it { expect(response).to render_template('edit') }
        it { expect(assigns(:article)).to_not be_nil }
        it { expect(assigns(:article)).to be_valid }
      end
    end

    describe :update do
      context "with an article" do
        let!(:article) { create(:article, body: "another *textile* test", user: user) }
        let!(:body) { "not the *same* text" }
        before(:each) { put :update, id: article.id, article: {body: body, text_filter: 'textile'} }
        it { expect(response).to redirect_to(action: 'index') }
        it { expect(article.reload.text_filter.name).to eq('textile') }
        it { expect(article.reload.body).to eq(body) }
      end
    end

    describe :destroy do
      context "with post method" do
        context "with an article from other user" do
          let(:article) { create(:article, user: create(:user, login: 'other_user')) }

          before(:each) { post :destroy, id: article.id }
          it { expect(response).to redirect_to(action: 'index') }
          it { expect(Article.count).to eq(1) }
        end

        context "with an article from user" do
          let(:article) { create(:article, user: user) }
          before(:each) { post :destroy, id: article.id }
          it { expect(response).to redirect_to(action: 'index') }
          it { expect(Article.count).to eq(0) }
        end
      end

      context "with get method" do
        context "with an article from other user" do
          let(:article) { create(:article, user: create(:user, login: 'other_user')) }

          before(:each) { get :destroy, id: article.id }
          it { expect(response).to redirect_to(action: 'index') }
          it { expect(Article.count).to eq(1) }
        end

        context "with an article from user" do
          let(:article) { create(:article, user: user) }
          before(:each) { get :destroy, id: article.id }
          it { expect(response).to render_template('admin/shared/destroy') }
          it { expect(Article.count).to eq(1) }
        end
      end
    end
  end
end
