require 'spec_helper'

describe "shared/_page_header.html.erb" do
  before do
    stub_default_blog
  end

  context "when rendered as if from the articles controller" do
    before do
      controller.request.path_parameters[:controller] = "articles"

    end

    it "shows the blog's custom tracking field if it exists" do
      Blog.default.custom_tracking_field = "the-custom-tracking-field"
      render

      rendered.should contain "the-custom-tracking-field"
    end
  end
end

