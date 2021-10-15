FactoryBot.define do
  factory :content do
    blog { Blog.first || create(:blog) }
  end
end
