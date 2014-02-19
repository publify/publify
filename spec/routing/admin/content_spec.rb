require 'spec_helper'

# TODO: Clean out non-resourceful routes
describe "Admin::ContentController routing" do
  it "routes #new" do
    { :get => "/admin/content/new"}.should route_to(controller: "admin/content",
                                                    action: "new", :id => nil)
  end

  it "routes #autosave" do
    { :post => "/admin/content/autosave"}.should route_to(controller: "admin/content", action: "autosave", :id => nil)
  end

  it "routes #auto_complete_for_article_keywords" do
    { :get => "/admin/content/auto_complete_for_article_keywords"}.should route_to(controller: "admin/content",
                                                                                   action: "auto_complete_for_article_keywords", :id => nil)
  end
end
