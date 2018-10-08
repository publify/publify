# frozen_string_literal: true

require 'rails_helper'

# Test article rendering for installed themes
RSpec.describe ArticlesController, type: :controller do
  render_views
  let(:blog) { create :blog }
  let(:article) { create :article, blog: blog }
  let(:from_param) { article.permalink_url.sub(/#{blog.base_url}/, '') }

  with_each_theme do |theme, _view_path|
    context "with theme #{theme} activated" do
      before do
        blog.theme = theme
        blog.save!
      end

      describe '#redirect' do
        it 'successfully renders an article' do
          get :redirect, params: { from: from_param }
          expect(response).to be_successful
        end
      end
    end
  end
end
