FactoryBot.define do
  factory :article do
    title { "A big article" }
    body { "A content with several data" }
    extended { "extended content for fun" }
    guid
    published_at { Time.zone.now }
    user
    allow_comments { true }
    state { :published }
    allow_pings { true }
    text_filter_name { "markdown" }

    after :build do |article|
      article.blog ||= Blog.first || create(:blog)
    end

    after :stub do |article|
      article.blog ||= Blog.first || create(:blog)
    end

    trait :with_tags do
      keywords { "a tag" }
    end
  end

  factory :unpublished_article, parent: :article do
    published_at { nil }
    state { :draft }
  end

  factory :full_article, parent: :article do
    after :create do |article|
      article.resources << create(:resource)
      article.tags << create(:tag)
    end
  end
end
