# frozen_string_literal: true

require "rails_helper"

describe "shared/_page_header.html.erb", type: :view do
  let!(:blog) { create :blog }

  context "when rendered as if from the articles controller" do
    before do
      controller.request.path_parameters[:controller] = "articles"
    end

    it "shows the blog's custom tracking field if it exists" do
      field_contents = <<-HTML
        <!-- tracking code -->
        <script>
          var tracker = 'foo';
          // expect some js here
        </script>
      HTML
      blog.update(custom_tracking_field: field_contents)
      render
      expect(rendered).to match field_contents
    end
  end
end
