# frozen_string_literal: true

class PopularSidebar < SidebarConfiguration
  description "Displays the most popular posts"
  setting :title, "Most popular"
  setting :count, 5, label: "Number articles"

  attr_accessor :popular

  def parse_request(_contents, _params)
    @popular = Article.bestof.limit(5)
  end
end

SidebarRegistry.register_sidebar PopularSidebar
