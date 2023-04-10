# frozen_string_literal: true

require "rails_helper"

RSpec.describe XmlController, type: :controller do
  render_views

  before do
    create(:blog, base_url: "http://myblog.net")
  end

  describe "#sitemap" do
    before do
      tag = create(:tag)
      article = create(:article)
      article.tags = [tag]
    end

    it "returns a valid XML response" do
      get :sitemap, format: :googlesitemap
      assert_xml @response.body
    end
  end
end
