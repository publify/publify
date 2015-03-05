require 'rails_helper'

describe Admin::UsersController, 'rough port of the old functional test', type: :controller do
  render_views

  describe ' when you are admin' do
    before(:each) do
      create(:blog)
      @admin = create(:user, profile: create(:profile_admin, label: Profile::ADMIN))
      request.session = { user: @admin.id }
    end

    it 'test_index' do
      get :index
      assert_template 'index'
      expect(assigns(:users)).not_to be_nil
    end

    it 'test_new' do
      get :new
      assert_template 'new'

      post :create, user: { login: 'errand', email: 'corey@test.com', password: 'testpass', password_confirmation: 'testpass', profile_id: 1, nickname: 'fooo', firstname: 'bar' }
      expect(response).to redirect_to(action: 'index')
    end

    describe '#EDIT action' do
      describe 'with POST request' do
        it 'should redirect to index' do
          post :update, id: @admin.id, user: { login: 'errand',
                                               email: 'corey@test.com', password: 'testpass',
                                               password_confirmation: 'testpass' }
          expect(response).to redirect_to(action: 'index')
        end
      end
    end
  end

  describe 'when you are not admin' do
    before :each do
      create(:blog)
      user = create(:user)
      session[:user] = user.id
    end

    it "don't see the list of user" do
      get :index
      expect(response).to redirect_to(controller: '/admin/dashboard', action: 'index')
    end

    describe 'EDIT Action' do
      describe 'try update another user' do
        before do
          @admin_profile = create(:profile_admin)
          @administrator = create(:user, profile: @admin_profile)
          contributor = create(:profile_contributor)
          post :edit,
               id: @administrator.id,
               profile_id: contributor.id
        end

        it 'should redirect to login' do
          expect(response).to redirect_to(controller: '/admin/dashboard', action: 'index')
        end

        it 'should not change user profile' do
          u = @administrator.reload
          expect(u.profile_id).to eq(@admin_profile.id)
        end
      end
    end
  end
end
