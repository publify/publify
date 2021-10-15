FactoryBot.define do
  factory :redirect do
    from_path { "foo/bar" }
    to_path { "/someplace/else" }
    blog { Blog.first || create(:blog) }
  end
end
