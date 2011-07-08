require 'spec_helper'

describe "admin/content/new.html.erb" do
  it "renders" do
    admin = stub_model(User, :editor => "simple", :admin? => true,
                       :text_filter_name => "", :profile_label => "admin")
    view.stub(:current_user) { admin }

    text_filter = "markdown smartypants".to_text_filter
    assign :article,
      stub_model(Article, :text_filter => text_filter).as_new_record
    assign(:images, [])
    assign(:macros, [])
    assign(:resources, [])
    render
  end
end
