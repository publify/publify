require 'rails_helper'

describe 'shared/_page_header.html.erb', type: :view do
  let!(:blog) { build_stubbed :blog }

  context 'when rendered as if from the articles controller' do
    before(:each) do
      controller.request.path_parameters[:controller] = 'articles'
    end

    it "shows the blog's custom tracking field if it exists" do
      Blog.default.custom_tracking_field = 'the-custom-tracking-field'
      render
      expect(rendered).to match 'the-custom-tracking-field'
    end
  end
end
