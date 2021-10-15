# frozen_string_literal: true

FactoryBot.define do
  factory :page do
    name { FactoryBot.generate(:name) }
    title { "Page One Title" }
    body { FactoryBot.generate(:body) }
    published_at { Time.zone.now }
    user
    blog { Blog.first || create(:blog) }
    state { "published" }
  end
end
