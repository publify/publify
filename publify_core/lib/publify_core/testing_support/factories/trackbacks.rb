FactoryBot.define do
  factory :trackback do
    state { "ham" }
    article
    blog_name { "Trackback Blog" }
    title { "Trackback Entry" }
    url { "http://www.example.com" }
    excerpt { "This is an excerpt" }
    guid { "dsafsadffsdsf" }
  end
end
