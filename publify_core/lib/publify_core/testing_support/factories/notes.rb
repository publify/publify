# frozen_string_literal: true

FactoryBot.define do
  factory :note do
    body { "this is a note" }
    published_at { Time.zone.now }
    user
    state { "published" }
    text_filter_name { "markdown" }
    guid
    blog { Blog.first || create(:blog) }
  end

  factory :unpublished_note, parent: :note do
    state { "draft" }
  end
end
