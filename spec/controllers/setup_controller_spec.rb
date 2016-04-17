require 'rails_helper'

describe SetupController, type: :controller do
  describe 'when no blog is configured' do
    before do
      # Set up database similar to result of seeding
      @blog = Blog.create
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

      before do
        post_setup_index
      end

      specify do
        expect(response).to redirect_to(controller: 'accounts',
                                        action: 'confirm')
      end

      it 'should correctly initialize blog and users' do
        expect(Blog.first.blog_name).to eq('Foo')
        admin = User.find_by_login('admin')
        expect(admin).not_to be_nil
        expect(admin.email).to eq('foo@bar.net')
        expect(Article.first.user).to eq(admin)
        expect(Page.first.user).to eq(admin)
      end

      it 'should log in admin user' do
        expect(controller.current_user).to eq(User.find_by_login('admin'))
      end
    end

    describe 'POST setup with incorrect parameters' do
      it 'empty blog name should raise an error' do
        post 'index', setting: { blog_name: '', email: 'foo@bar.net' }
        expect(response).to redirect_to(action: 'index')
      end

      it 'empty email should raise an error' do
        post 'index', setting: { blog_name: 'Foo', email: '' }
        expect(response).to redirect_to(action: 'index')
      end
    end
  end

  describe 'when a blog is configured and has some users' do
    before do
      create(:blog)
    end

    describe 'GET setup' do
      before do
        get 'index'
      end

      specify { expect(response).to redirect_to(controller: 'articles', action: 'index') }
    end

    describe 'POST setup' do
      before do
        post 'index', setting: { blog_name: 'Foo', email: 'foo@bar.net' }
      end

      specify { expect(response).to redirect_to(controller: 'articles', action: 'index') }

      it 'should not initialize blog and users' do
        expect(Blog.first.blog_name).not_to eq('Foo')
        admin = User.find_by_login('admin')
        expect(admin).to be_nil
      end
    end
  end
end
