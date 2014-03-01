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

      context "when use_meta_keyword set to true" do
        let!(:blog) { create(:blog, use_meta_keyword: true) }
        before(:each) {render}
        it { expect(rendered).to have_selector('head>meta[name="keywords"]') }
      end

      context "when use_meta_keyword set to false" do
        let!(:blog) { create(:blog, use_meta_keyword: false) }
        before(:each) {render}
        it { expect(rendered).to_not have_selector('head>meta[name="keywords"]') }
      end
    end
  end
end

