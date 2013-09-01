require 'spec_helper'

describe "admin/pages/new.html.erb" do
  before do
    create(:blog)
    text_filter = create(:markdown)
    @page = create(:page, text_filter: text_filter)
    view.stub(:current_user) { create(:user) }
  end

  it "renders with no resources or macros" do
    assign(:images, [])
    assign(:macros, [])
    assign(:resources, [])
    render
  end

  it "renders with image resources" do
    # FIXME: Nasty. Thumbnail creation should not be controlled by the view.
    img = mock_model(Resource, filename: "foo", create_thumbnail: nil, upload: double(:uploader, url: "example.com", thumb: double(:thumb, url: "example.com")))
    assign(:images, [img])
    assign(:macros, [])
    assign(:resources, [])
    render
  end
end

