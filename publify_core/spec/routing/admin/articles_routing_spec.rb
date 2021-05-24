# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin::ContentController routing", type: :routing do
  it "routes #new" do
    expect(get: "/admin/articles/new").to route_to(controller: "admin/articles",
                                                   action: "new")
  end

  it "routes #autosave" do
    expect(post: "/admin/articles/autosave").
      to route_to(controller: "admin/articles", action: "autosave")
  end

  it "routes #auto_complete_for_article_keywords" do
    expect(get: "/admin/articles/auto_complete_for_article_keywords").
      to route_to(controller: "admin/articles",
                  action: "auto_complete_for_article_keywords")
  end
end
