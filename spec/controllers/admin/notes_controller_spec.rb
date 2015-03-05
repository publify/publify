require 'rails_helper'

describe Admin::NotesController, type: :controller do
  render_views

  before(:each) { request.session = { user: admin.id } }

  context 'with a blog' do
    let(:admin) { create(:user, :as_admin) }
    let!(:blog) { create(:blog) }

    describe 'index' do
      let!(:notes) { [create(:note), create(:note)] }
      before(:each) { get :index }
      it { expect(response).to render_template('index') }
      it { expect(assigns(:notes).sort).to eq(notes.sort) }
      it { expect(assigns(:note)).to be_a(Note) }
      it { expect(assigns(:note).author).to eq(admin.login) }
      it { expect(assigns(:note).user).to eq(admin) }
    end

    describe 'create' do
      context 'a simple note' do
        before(:each) { post :create, note: { body: 'Emphasis _mine_' } }
        it { expect(response).to redirect_to(admin_notes_path) }
        it { expect(flash[:notice]).to eq(I18n.t('notice.note_successfully_created')) }
      end

      it do
        expect do
          post :create, note: { body: 'Emphasis _mine_' }
        end.to change { Note.count }.from(0).to(1) end
    end

    context 'with an existing note from current user' do
      let(:note) { create(:note, user_id: admin) }

      describe 'edit' do
        before(:each) { get :edit, id: note.id }
        it { expect(response).to be_success }
        it { expect(response).to render_template('edit') }
        it { expect(assigns(:note)).to eq(note) }
        it { expect(assigns(:notes)).to eq([note]) }
      end

      describe 'update' do
        before(:each) { post :update, id: note.id, note: { body: 'new body' } }
        it { expect(response).to redirect_to(action: :index) }
        it { expect(note.reload.body).to eq('new body') }
      end

      describe 'show' do
        before(:each) { get :show, id: note.id }
        it { expect(response).to render_template('show') }
      end

      describe 'Destorying a note' do
        before(:each) { post :destroy, id: note.id }
        it { expect(response).to redirect_to(admin_notes_path) }
        it { expect(Note.count).to eq(0) }
      end
    end
  end

  context 'with a blog with twitter configured' do
    let!(:blog) { create(:blog_with_twitter) }
    let(:admin) { create(:user, :as_admin, :with_twitter) }

    describe 'edit' do
      context 'when push to twitter' do
        it 'call note to send to twitter' do
          expect(Note.count).to eq(0)
          twitter_cli = double(twitter_cli)
          expect(Twitter::Client).to receive(:new).and_return(twitter_cli)
          Tweet = Struct.new(:attrs)
          tweet = Tweet.new(id_str: '2344')
          expect(twitter_cli).to receive(:update).and_return(tweet)
          post :create, note: { body: 'Emphasis _mine_, arguments *strong*' }, push_to_twitter: 'true'
          expect(Note.first.twitter_id).to eq('2344')
        end
      end
    end
  end
end
