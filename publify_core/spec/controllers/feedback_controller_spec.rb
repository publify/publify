require 'rails_helper'

RSpec.describe FeedbackController, type: :controller do
  describe 'index' do
    let!(:items) do
      [
        create(:comment),
        create(:comment),
        create(:trackback, title: 'some'),
        create(:trackback, title: 'items')
      ]
    end

    context 'with atom format' do
      before(:each) { get 'index', params: { format: 'atom' } }

      it "responds with success" do
        expect(response).to be_success
      end

      it "assigns all feedback" do
        expect(assigns(:feedback)).to match_array items
      end

      it "renders the index template" do
        expect(response).to render_template('feedback/index')
      end

      context 'with rendered views' do
        render_views

        it 'renders a valid atom feed with 4 items' do
          assert_atom10 response.body, 4
        end

        it 'renders each item with the correct template' do
          expect(response).
            to render_template(partial: 'shared/_atom_item_comment', count: 2).
            and  render_template(partial: 'shared/_atom_item_trackback', count: 2)
        end
      end
    end

    context 'with rss format' do
      before { get 'index', params: { format: 'rss' } }

      it "responds with success" do
        expect(response).to be_success
      end

      it "assigns all feedback" do
        expect(assigns(:feedback)).to match_array items
      end

      it "renders the index template" do
        expect(response).to render_template('feedback/index')
      end

      context 'with rendered views' do
        render_views

        it 'renders a valid rss feed with 4 items' do
          assert_rss20 response.body, 4
        end

        it 'renders each item with the correct template' do
          expect(response).
            to render_template(partial: 'shared/_rss_item_comment', count: 2).
            and  render_template(partial: 'shared/_rss_item_trackback', count: 2)
        end
      end
    end
  end
end
