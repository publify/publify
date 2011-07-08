require 'spec_helper'

describe "admin/content/new.html.erb" do
  it "renders" do
    user = double(:user, :text_filter_name => "",
                  :editor => "simple", :admin? => true)
    view.stub(:current_user) { user }
    view.stub(:subtabs_for) {""}

    text_filter = "markdown smartypants".to_text_filter
    assign(:article, stub_model(Article, :text_filter => text_filter))
    assign(:images, [])
    assign(:macros, [])
    assign(:resources, [])
    render
  end
end
