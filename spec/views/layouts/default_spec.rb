require 'spec_helper'

describe "layouts/default.html.erb" do
  with_each_theme do |theme, view_path|
    describe theme ? "with theme #{theme}" : "without a theme" do
      before(:each) do
        assign(:keywords, ["foo", "bar"])
        assign(:auto_discovery_url_atom, "")
        assign(:auto_discovery_url_rss, "")
        @controller.view_paths.unshift(view_path) if theme
      end

      it "has keyword meta tag when use_meta_keyword set to true" do
        create(:blog, use_meta_keyword: true)
        render
        expect(rendered).to have_selector('head>meta[name="keywords"]')
      end

      it "does not have keyword meta tag when use_meta_keyword set to false" do
        create(:blog, use_meta_keyword: false)
        render
        expect(rendered).to_not have_selector('head>meta[name="keywords"]')
      end
    end
  end
end

