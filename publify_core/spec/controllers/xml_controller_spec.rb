# frozen_string_literal: true

require 'rails_helper'

RSpec.describe XmlController, type: :controller do
  before do
    create(:blog, base_url: 'http://myblog.net')
    allow(Trigger).to receive(:fire) {}
  end

  describe '#sitemap' do
    render_views
    before do
      tag = create(:tag)
      article = create :article
      article.tags = [tag]
      get :sitemap, format: :googlesitemap
    end

    it 'is succesful' do
      assert_response :success
    end

    it 'returns a valid XML response' do
      assert_xml @response.body
    end
  end
end
