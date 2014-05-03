require 'spec_helper'

describe NotesController do
  render_views
  let!(:blog) { create(:blog) }

  describe :index do
    context "normally" do
      let!(:note) { create(:note) }
      before(:each) { get 'index' }

      it { expect(response).to be_success }
      it { expect(response).to render_template('notes/index') }
      it { expect(assigns(:notes)).to eq([note]) }
    end

    context "with no note" do
      before(:each) { get 'index' }
      it { expect(response).to be_success }
      it { expect(response).to render_template('notes/error') }
    end
  end

  describe :show do
    before(:each) { get :show, permalink: permalink }

    context "normal" do
      let(:permalink) { "#{create(:note).id}-this-is-a-note" }

      it { expect(response).to be_success }
      it { expect(assigns[:page_title]).to eq('Notes | test blog ') }
    end

    context "note not found" do
      let(:permalink) { "thistagdoesnotexist" }

      it { expect(response).to be_not_found }
      it { expect(response).to render_template('errors/404') }
    end
  end
end
