# frozen_string_literal: true

FactoryBot.define do
  factory :sidebar do
    active_position { 1 }
    config { { "title" => "Links", "body" => "some links" } }
    type { "StaticSidebar" }
    blog { Blog.first || create(:blog) }
  end
end
