require 'spec_helper'

describe "admin/pages/new.html.erb" do
  before do
    admin = stub_model(User, :settings => { :editor => 'simple' }, :admin? => true,
                       :text_filter_name => "", :profile_label => "admin")
    blog = mock_model(Blog, :base_url => "http://myblog.net/")
    page = stub_model(Page).as_new_record
    text_filter = stub_model(TextFilter, :description => 'None')

    page.stub(:text_filter) { text_filter }
    view.stub(:current_user) { admin }
    view.stub(:this_blog) { blog }

    # FIXME: Nasty. Controller should pass in @categories and @textfilters.
    Category.stub(:all) { [] }
    TextFilter.stub(:all) { [text_filter] }

    assign :page, page
  end

  it "renders with no resources or macros" do
    assign(:images, [])
    assign(:macros, [])
    assign(:resources, [])
    render
  end

  it "renders with image resources" do
    # FIXME: Nasty. Thumbnail creation should not be controlled by the view.
    img = mock_model(Resource, :filename => "foo", :create_thumbnail => nil, :upload => mock(:uploader, :url => "example.com", :thumb => mock(:thumb, :url => "example.com")))
    assign(:images, [img])
    assign(:macros, [])
    assign(:resources, [])
    render
  end
end

