require 'spec_helper'

describe "admin/content/new.html.erb" do
  before do
    admin = stub_model(User, :editor => "simple", :admin? => true,
                       :text_filter_name => "", :profile_label => "admin")
    blog = mock_model(Blog, :base_url => "http://myblog.net/")

    view.stub(:current_user) { admin }
    view.stub(:this_blog) { blog }

    text_filter = "markdown smartypants".to_text_filter
    assign :article,
      stub_model(Article, :text_filter => text_filter).as_new_record
  end

  it "renders with no resources or macros" do
    assign(:images, [])
    assign(:macros, [])
    assign(:resources, [])
    render
  end

  it "renders with image resources" do
    assign(:images, [stub_model(Resource)])
    assign(:macros, [])
    assign(:resources, [])
    render
  end
end
