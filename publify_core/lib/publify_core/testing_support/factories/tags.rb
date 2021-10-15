FactoryBot.define do
  factory :tag do |tag|
    tag.name { FactoryBot.generate(:name) }
    tag.display_name { |a| a.name } # rubocop:disable Style/SymbolProc
    blog { Blog.first || create(:blog) }
  end
end
