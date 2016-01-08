require 'rails_helper'

describe Admin::MigrationsController, type: :controller do
  let!(:blog) { create(:blog) }
  let(:admin) { create(:user, :as_admin) }

  before do
    sign_in admin
  end

  describe '#show' do
    render_views

    context 'without migrations pending' do
      before do
        get :show
      end

      it 'renders the show template' do
        expect(response).to render_template('show')
      end

      it 'responds with success' do
        expect(response).to be_success
      end
    end

    context 'with migrations pending' do
      let(:migrator) { Migrator.new }

      before do
        allow(Migrator).to receive(:new).and_return migrator
        allow(migrator).to receive(:migrations_pending?).and_return true
        get :show
      end

      it 'does not redirect' do
        expect(response).to be_success
      end
    end
  end
end
