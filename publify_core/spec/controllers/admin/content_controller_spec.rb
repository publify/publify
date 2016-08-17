require 'rails_helper'

describe Admin::ContentController, type: :controller do
  render_views

  let(:admin) { create(:user, :as_admin, text_filter: create(:markdown)) }
  let(:publisher) { create(:user, :as_publisher, text_filter: create(:markdown)) }
  let(:contributor) { create(:user, :as_contributor) }

  before do
    create :blog
  end

  describe 'index' do
    let!(:article) { create(:article) }

    before do
      sign_in publisher
    end

    context 'simple query' do
      before(:each) { get :index }
      it { expect(response).to be_success }
      it { expect(response).to render_template('index', layout: 'administration') }
    end

    it 'return article that match with search query' do
      get :index, search: { searchstring: article.body[0..4] }
      expect(assigns(:articles)).to eq([article])
    end

    it 'search query and limit on published_at' do
      get :index, search: {
        searchstring: article.body[0..4],
        published_at: article.published_at + 2.days
      }
      expect(assigns(:articles)).to be_empty
    end

    context 'search for state' do
      let!(:draft_article) { create(:article, state: 'draft') }
      let!(:pending_article) { create(:article, state: 'publication_pending', published_at: '2020-01-01') }
      before(:each) { get :index, search: state }

      context 'draft only' do
        let(:state) { { state: 'drafts' } }
        it { expect(assigns(:articles)).to eq([draft_article]) }
      end

      context 'publication_pending only' do
        let(:state) { { state: 'pending' } }
        it { expect(assigns(:articles)).to eq([pending_article]) }
      end

      context 'with a bad state' do
        let(:state) { { state: '3vI1 1337 h4x0r' } }
        it { expect(assigns(:articles).sort).to eq([article, pending_article, draft_article].sort) }
      end
    end
  end

  describe '#autosave' do
    before do
      sign_in publisher
    end

    context 'first time save' do
      it 'creates a new draft Article' do
        expect do
          xhr :post, :autosave, article: attributes_for(:article)
        end.to change(Article, :count).by(1)
      end

      it 'creates tags for the draft article if relevant' do
        expect do
          xhr :post, :autosave, article: attributes_for(:article, :with_tags)
        end.to change(Tag, :count).by(2)
      end
    end

    context 'second call to save' do
      let!(:draft) { create(:article, published: false, state: 'draft') }

      it 'does not create an extra draft' do
        expect do
          xhr :post, :autosave, article: { id: draft.id, body_and_extended: 'new body' }
        end.to_not change(Article, :count)
      end
    end

    context 'with an other existing draft' do
      let!(:draft) { create(:article, published: false, state: 'draft', body: 'existing body') }

      it 'creates a new draft Article' do
        expect do
          xhr :post, :autosave, article: attributes_for(:article)
        end.to change(Article, :count).by(1)
      end

      it 'does not replace existing draft' do
        xhr :post, :autosave, article: attributes_for(:article)
        expect(assigns(:article).id).to_not eq(draft.id)
        expect(assigns(:article).body).to_not eq(draft.body)
      end
    end
  end

  describe '#new' do
    before do
      sign_in publisher
      get :new
    end

    it { expect(response).to be_success }
    it { expect(response).to render_template('new') }
    it { expect(assigns(:article)).to_not be_nil }
    it { expect(assigns(:article).redirect).to be_nil }
  end

  describe '#create' do
    shared_examples_for 'create action' do
      def base_article(options = {})
        { title: 'posted via tests!',
          body: 'A good body',
          allow_comments: '1',
          allow_pings: '1' }.merge(options)
      end

      it 'should send notifications on create' do
        begin
          u = create(:user, notify_via_email: true, notify_on_new_articles: true)
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
        post :create, 'article' => base_article(keywords: 'foo bar')
        new_article = Article.last
        assert_equal 2, new_article.tags.size
      end

      it 'should create an article with a uniq Tag instace named lang:FR' do
        post :create, 'article' => base_article(keywords: 'lang:FR')
        new_article = Article.last
        expect(new_article.tags.map(&:name).include?('lang-fr')).to be_truthy
      end

      it 'should correctly interpret time zone in :published_at' do
        post :create, 'article' => base_article(published_at: 'February 17, 2011 08:47 PM GMT+0100 (CET)')
        new_article = Article.last
        assert_equal Time.utc(2011, 2, 17, 19, 47), new_article.published_at
      end

      it 'should respect "GMT+0000 (UTC)" in :published_at' do
        post :create, 'article' => base_article(published_at: 'August 23, 2011 08:40 PM GMT+0000 (UTC)')
        new_article = Article.last
        assert_equal Time.utc(2011, 8, 23, 20, 40), new_article.published_at
      end

      it 'should create a filtered article' do
        Article.delete_all
        body = 'body via *markdown*'
        extended = '*foo*'
        post :create, 'article' => { title: 'another test', body: body, extended: extended }

        assert_response :redirect, action: 'index'

        new_article = Article.order(created_at: :desc).first

        expect(new_article.body).to eq body
        expect(new_article.extended).to eq extended
        expect(new_article.text_filter.name).to eq @user.text_filter.name
        expect(new_article.html(:body)).to eq '<p>body via <em>markdown</em></p>'
        expect(new_article.html(:extended)).to eq '<p><em>foo</em></p>'
      end

      context 'with a previously autosaved draft' do
        before do
          @draft = create(:article, body: 'draft', state: 'draft', published: false)
          post(:create, article: { id: @draft.id, body: 'update', published: true })
        end

        it 'updates the draft' do
          expect(Article.find(@draft.id).body).to eq 'update'
        end

        it 'makes the draft published' do
          expect(Article.find(@draft.id)).to be_published
        end
      end

      describe 'with an unrelated draft in the database' do
        before do
          @draft = create(:article, state: 'draft')
        end

        describe 'saving new article as draft' do
          it 'leaves the original draft in existence' do
            post :create, article: base_article(draft: 'save as draft')
            expect(assigns(:article).id).not_to eq(@draft.id)
            expect(Article.find(@draft.id)).not_to be_nil
          end
        end
      end
    end

    context 'as a publisher' do
      before do
        sign_in publisher
        @user = publisher
      end

      let(:article_params) { { title: 'posted via tests!', body: 'a good boy' } }

      it 'creates an article' do
        expect do
          post :create, article: article_params
        end.to change(Article, :count).by(1)
      end

      context 'classic' do
        before(:each) { post :create, article: article_params }

        it { expect(response).to redirect_to(action: :index) }
        it { expect(flash[:success]).to eq(I18n.t('admin.content.create.success')) }

        it { expect(assigns(:article)).to be_published }
        it { expect(assigns(:article).user).to eq(publisher) }

        context 'when doing a draft' do
          let(:article_params) { { title: 'posted via tests!', body: 'a good boy', state: 'draft' } }
          it { expect(assigns(:article)).to_not be_published }
        end
      end

      context 'write for futur' do
        let(:article_params) { { title: 'posted via tests!', body: 'a good boy', state: 'draft', published_at: (Time.now + 1.hour).to_s } }

        it 'creates an article' do
          expect do
            post :create, article: article_params
          end.to change(Article, :count).by(1)
        end

        it 'does not create a short url' do
          expect do
            post :create, article: article_params
          end.to_not change(Redirect, :count)
        end

        it 'creates a trigger to publish the article' do
          expect do
            post :create, article: article_params
          end.to change(Trigger, :count).by(1)
        end
      end
    end

    context 'as an admin' do
      before(:each) do
        sign_in admin
        @user = admin
      end

      it_should_behave_like 'create action'
    end
  end

  describe '#edit' do
    context 'as an admin' do
      let(:article) { create(:article) }

      before do
        sign_in admin
      end

      it 'should edit article' do
        get :edit, 'id' => article.id
        expect(response).to render_template 'edit'
        expect(assigns(:article)).not_to be_nil
        expect(assigns(:article)).to be_valid
        expect(response.body).to match(/body/)
        expect(response.body).to match(/extended content/)
      end

      it 'correctly converts multi-word tags' do
        a = create(:article, keywords: '"foo bar", baz')
        get :edit, id: a.id
        expect(response.body).to have_selector("input[id=article_keywords][value='baz, \"foo bar\"']")
      end
    end

    context 'as a publisher' do
      before do
        sign_in publisher
      end

      context 'with an article from an other user' do
        let(:article) { create(:article, user: create(:user, login: 'another_user')) }

        before(:each) { get :edit, id: article.id }
        it { expect(response).to redirect_to(action: 'index') }
      end

      context 'with an article from current user' do
        let(:article) { create(:article, user: publisher) }

        before(:each) { get :edit, id: article.id }
        it { expect(response).to render_template('edit') }
        it { expect(assigns(:article)).to_not be_nil }
        it { expect(assigns(:article)).to be_valid }
      end
    end
  end

  describe '#update' do
    context 'as an admin' do
      let(:article) { create(:article) }

      before do
        sign_in admin
      end

      it 'should update article' do
        begin
          ActionMailer::Base.perform_deliveries = true
          emails = ActionMailer::Base.deliveries
          emails.clear

          art_id = article.id

          body = 'another *textile* test'
          put :update, 'id' => art_id, 'article' => { body: body, text_filter: 'textile' }
          assert_response :redirect, action: 'show', id: art_id

          article.reload
          expect(article.text_filter.name).to eq('textile')
          expect(body).to eq(article.body)

          expect(emails.size).to eq(0)
        ensure
          ActionMailer::Base.perform_deliveries = false
        end
      end

      it 'should allow updating body_and_extended' do
        put :update, 'id' => article.id, 'article' => {
          'body_and_extended' => 'foo<!--more-->bar<!--more-->baz'
        }
        assert_response :redirect
        article.reload
        expect(article.body).to eq('foo')
        expect(article.extended).to eq('bar<!--more-->baz')
      end

      context 'when a published article has drafts' do
        let(:original_published_at) { 2.days.ago.to_date }
        let!(:original) { create(:article, published_at: original_published_at) }
        let!(:draft) { create(:article, parent_id: original.id, state: 'draft', published: false) }
        let!(:second_draft) { create(:article, parent_id: original.id, state: 'draft', published: false) }

        describe 'publishing the published article' do
          before do
            put(:update,
                id: original.id,
                article: { id: draft.id, body: 'update' })
          end

          it 'updates the article' do
            expect(original.reload.body).to eq 'update'
          end

          it 'deletes all drafts' do
            assert_raises ActiveRecord::RecordNotFound do
              Article.find(draft.id)
            end
            assert_raises ActiveRecord::RecordNotFound do
              Article.find(second_draft.id)
            end
          end

          it 'keeps the original publication date' do
            expect(original.reload.published_at).to eq original_published_at
          end
        end

        describe 'publishing a draft copy of the published article' do
          before do
            put(:update,
                id: draft.id,
                article: { id: draft.id, body: 'update', published_at: '' })
          end

          it 'updates the original' do
            expect(original.reload.body).to eq('update')
          end

          it 'deletes all drafts' do
            assert_raises ActiveRecord::RecordNotFound do
              Article.find(draft.id)
            end
            assert_raises ActiveRecord::RecordNotFound do
              Article.find(second_draft.id)
            end
          end

          it 'keeps the original publication date' do
            expect(original.reload.published_at).to eq original_published_at
          end
        end

        describe 'publishing a draft copy with a new publication date' do
          before do
            put(:update,
                id: draft.id,
                article: { id: draft.id, body: 'update', published_at: '2016-07-07' })
          end

          it 'updates the original publication date' do
            expect(original.reload.published_at).to eq Date.new(2016, 7, 7)
          end
        end
      end

      describe 'saving a published article as draft' do
        before do
          @orig = create(:article)
          put(:update,
              id: @orig.id,
              article: { title: @orig.title, draft: 'draft',
                         body: 'update' })
        end

        it 'leaves the original published' do
          @orig.reload
          expect(@orig.published).to eq(true)
        end

        it 'leaves the original as is' do
          @orig.reload
          expect(@orig.body).not_to eq('update')
        end

        it 'redirects to the index' do
          expect(response).to redirect_to(action: 'index')
        end

        it 'creates a draft' do
          draft = Article.child_of(@orig.id).first
          expect(draft.parent_id).to eq(@orig.id)
          expect(draft).not_to be_published
        end
      end
    end

    context 'as a publisher' do
      before do
        sign_in publisher
      end

      context 'with an article' do
        let!(:article) { create(:article, body: 'another *textile* test', user: publisher) }
        let!(:body) { 'not the *same* text' }
        before(:each) { put :update, id: article.id, article: { body: body, text_filter: 'textile' } }
        it { expect(response).to redirect_to(action: 'index') }
        it { expect(article.reload.text_filter.name).to eq('textile') }
        it { expect(article.reload.body).to eq(body) }
      end
    end
  end

  describe '#auto_complete_for_article_keywords' do
    before do
      sign_in publisher
    end

    before do
      create(:tag, name: 'foo', articles: [create(:article)])
      create(:tag, name: 'bazz', articles: [create(:article)])
      create(:tag, name: 'bar', articles: [create(:article)])
    end

    it 'should return foo for keywords fo' do
      get :auto_complete_for_article_keywords, article: { keywords: 'fo' }
      expect(response).to be_success
      expect(response.body).to eq('["bar","bazz","foo"]')
    end
  end

  describe '#destroy' do
    before do
      sign_in publisher
    end

    context 'with an article from other user' do
      let(:article) { create(:article, user: create(:user, login: 'other_user')) }

      before(:each) { delete :destroy, id: article.id }
      it { expect(response).to redirect_to(action: 'index') }
      it { expect(Article.count).to eq(1) }
    end

    context 'with an article from user' do
      let(:article) { create(:article, user: publisher) }
      before(:each) { delete :destroy, id: article.id }
      it { expect(response).to redirect_to(action: 'index') }
      it { expect(Article.count).to eq(0) }
    end
  end
end
