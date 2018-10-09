# frozen_string_literal: true

require 'rails_helper'

describe NotesController, type: :controller do
  render_views
  let!(:blog) { create(:blog) }

  describe '#index' do
    context 'normally' do
      let!(:note) { create(:note) }

      before { get 'index' }

      it { expect(response).to be_successful }
      it { expect(response).to render_template('notes/index') }
      it { expect(assigns(:notes)).to eq([note]) }
    end

    context 'with no note' do
      before { get 'index' }

      it { expect(response).to be_successful }
      it { expect(response).to render_template('notes/error') }
    end
  end

  describe '#show' do
    context 'normal' do
      let(:permalink) { "#{create(:note).id}-this-is-a-note" }

      before { get :show, params: { permalink: permalink } }

      it { expect(response).to be_successful }
      it { expect(response).to render_template('show') }
      it { expect(assigns[:page_title]).to eq('Notes | test blog ') }
    end

    context 'in reply' do
      let(:reply) do
        {
          'id_str' => '123456789',
          'created_at' => DateTime.new(2014, 1, 23, 13, 47).in_time_zone,
          'user' => {
            'screen_name' => 'a screen name',
            'entities' => {
              'url' => {
                'urls' => [{ 'expanded_url' => 'an url' }]
              }
            }
          }
        }
      end
      let(:permalink) { "#{create(:note, in_reply_to_message: reply.to_json).id}-this-is-a-note" }

      before { get :show, params: { permalink: permalink } }

      it { expect(response).to be_successful }
      it { expect(response).to render_template('show_in_reply') }
      it { expect(assigns[:page_title]).to eq('Notes | test blog ') }
    end

    context 'note not found' do
      let(:permalink) { 'thistagdoesnotexist' }

      it 'raises RecordNotFound' do
        expect { get :show, params: { permalink: permalink } }.
          to raise_error ActiveRecord::RecordNotFound
      end
    end
  end
end
