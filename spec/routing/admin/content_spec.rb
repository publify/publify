require 'spec_helper'

# TODO: Clean out non-resourceful routes
describe "Admin::ContentController routing" do
  it "routes #new" do
    { :get => "/admin/content/new"}.should route_to(controller: "admin/content",
                                                    action: "new")
  end

  it "routes #autosave" do
    { :post => "/admin/content/autosave"}.should route_to(controller: "admin/content",
                                                          action: "autosave")
  end

  it "routes #insert_editor" do
    { :get => "/admin/content/insert_editor"}.should route_to(controller: "admin/content",
                                                              action: "insert_editor")
  end

  it "routes #auto_complete_for_article_keywords" do
    { :get => "/admin/content/auto_complete_for_article_keywords"}.should route_to(controller: "admin/content",
                                                                                   action: "auto_complete_for_article_keywords")
  end

  it "routes #attachment_box_add" do
    { :get => "/admin/content/23/attachment_box_add"}.should route_to(controller: "admin/content",
                                                                      action: "attachment_box_add",
                                                                      id: "23")
  end

  it "routes #resource_add" do
    { :get => "/admin/content/23/resource_add"}.should route_to(controller: "admin/content",
                                                                action: "resource_add",
                                                                id: "23")
  end

  it "routes #resource_remove" do
    { :get => "/admin/content/23/resource_remove"}.should route_to(controller: "admin/content",
                                                                   action: "resource_remove",
                                                                   id: "23")
  end
end
