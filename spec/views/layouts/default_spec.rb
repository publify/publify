require 'spec_helper'

describe "layouts/default.html.erb" do
  before do
    assign(:keywords, ["foo", "bar"])
    assign(:auto_discovery_url_atom, "")
    assign(:auto_discovery_url_rss, "")
  end

  with_each_theme do |theme, view_path|
    # FIXME: Add default.html.erb in base view dir.
    next unless theme

    describe theme ? "with theme #{theme}" : "without a theme" do
      before do
        @controller.view_paths.unshift(view_path) if theme
      end

      context "when use_meta_keyword set to true" do
        before do
          @blog = FactoryGirl.create(:blog, :use_meta_keyword => true)
        end

        it 'renders assigned keywords' do
          render
          rendered.should have_selector('head>meta[name="keywords"]')
        end
      end

      context "when use_meta_keyword set to false" do
        before do
          @blog = FactoryGirl.create(:blog, :use_meta_keyword => false)
        end

        it 'does not render assigned keywords' do
          render
          rendered.should_not have_selector('head>meta[name="keywords"]')
        end
      end
    end
  end
end

