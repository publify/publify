require 'rails_helper'

describe SetupController, type: :controller do
  describe 'when no blog is configured' do
    before do
      # Set up database similar to result of seeding
      Blog.new.save
      create :tag
      create :none
    end

    describe 'GET setup' do
      before do
        get 'index'
      end

      specify { expect(response).to render_template('index') }
    end

    describe 'POST setup' do
      let(:post_setup_index) do
        post 'index', setting: { blog_name: 'Foo', email: 'foo@bar.net' }
      end

      context 'when a first article exists' do
        before do
          Article.create(title: 'First post').save!
          post_setup_index
        end

        specify do
          expect(response).to redirect_to(controller: 'accounts',
                                          action: 'confirm')
        end

        it 'should correctly initialize blog and users' do
          expect(Blog.default.blog_name).to eq('Foo')
          admin = User.find_by_login('admin')
          expect(admin).not_to be_nil
          expect(admin.email).to eq('foo@bar.net')
          expect(Article.first.user).to eq(admin)
          expect(Page.first.user).to eq(admin)
        end

        it 'should log in admin user' do
          expect(session[:user_id]).to eq(User.find_by_login('admin').id)
        end
      end

      context 'when no first article exists' do
        before do
          post_setup_index
        end

        specify do
          expect(response).to redirect_to(controller: 'accounts',
                                          action: 'confirm')
        end

        it 'should correctly initialize blog and users' do
          expect(Blog.default.blog_name).to eq('Foo')
          admin = User.find_by_login('admin')
          expect(admin).not_to be_nil
          expect(admin.email).to eq('foo@bar.net')
          expect(Article.first.user).to eq(admin)
          expect(Page.first.user).to eq(admin)
        end

        it 'should log in admin user' do
          expect(session[:user_id]).to eq(User.find_by_login('admin').id)
        end
      end
    end
  end

  describe 'POST setup with incorrect parameters' do
    before do
      Blog.delete_all
      User.delete_all
      Blog.new.save
    end

    it 'empty blog name should raise an error' do
      post 'index', setting: { blog_name: '', email: 'foo@bar.net' }
      expect(response).to redirect_to(action: 'index')
    end

    it 'empty email should raise an error' do
      post 'index', setting: { blog_name: 'Foo', email: '' }
      expect(response).to redirect_to(action: 'index')
    end
  end

  describe 'when a blog is configured and has some users' do
    describe 'GET setup' do
      before do
        FactoryGirl.create(:blog)
        get 'index'
      end

      specify { expect(response).to redirect_to(controller: 'articles', action: 'index') }
    end

    describe 'POST setup' do
      before do
        FactoryGirl.create(:blog)
        post 'index', setting: { blog_name: 'Foo', email: 'foo@bar.net' }
      end

      specify { expect(response).to redirect_to(controller: 'articles', action: 'index') }

      it 'should not initialize blog and users' do
        expect(Blog.default.blog_name).not_to eq('Foo')
        admin = User.find_by_login('admin')
        expect(admin).to be_nil
      end
    end
  end
end
