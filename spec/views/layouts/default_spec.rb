# frozen_string_literal: true

require "rails_helper"

RSpec.describe "layouts/default.html.erb", type: :view do
  with_each_theme do |theme, view_path|
    describe "with theme #{theme}" do
      before do
        assign(:keywords, %w(foo bar))
        assign(:auto_discovery_url_atom, "")
        assign(:auto_discovery_url_rss, "")
        @controller.view_paths.unshift(view_path) if theme
      end

      it "has keyword meta tag when use_meta_keyword set to true" do
        create(:blog, use_meta_keyword: true)
        render
        expect(rendered).to have_selector('head>meta[name="keywords"]', visible: :all)
      end

      it "does not have keyword meta tag when use_meta_keyword set to false" do
        create(:blog, use_meta_keyword: false)
        render
        expect(rendered).not_to have_selector('head>meta[name="keywords"]', visible: :all)
      end
    end
  end
end
